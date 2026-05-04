#!/usr/bin/env python3
import inkex
import os
import subprocess
import tempfile
import re
import uuid
from lxml import etree

# --- CONFIGURATION ---
# Change this to match your terminal. 
# e.g., ['kitty', '--'] or ['alacritty', '-e'] or ['x-terminal-emulator', '-e']
TERMINAL_CMD = ['kitty', '--'] 
EDITOR_CMD = 'nvim'
# ---------------------

def prefix_ids(svg_str, prefix):
    """Prefix all IDs and their references to avoid collisions when inserting multiple equations."""
    svg_str = re.sub(r'id="([^"]+)"', lambda m: f'id="{prefix}-{m.group(1)}"', svg_str)
    svg_str = re.sub(r'url\(#([^)]+)\)', lambda m: f'url(#{prefix}-{m.group(1)})', svg_str)
    svg_str = re.sub(r'href="#([^"]+)"', lambda m: f'href="#{prefix}-{m.group(1)}"', svg_str)
    return svg_str

class NeovimLatex(inkex.EffectExtension):
    def effect(self):
        # 1. Check for selected node to update, or start fresh
        selected_node = None
        latex_code = r"E = mc^2"
        font_size = "12pt"

        if self.svg.selection:
            # Look for an item with our custom data attribute
            for node in self.svg.selection.values():
                if node.get('data-latex-code'):
                    selected_node = node
                    latex_code = node.get('data-latex-code')
                    font_size = node.get('data-font-size', '12pt')
                    break

        # 2. Prepare the workspace
        with tempfile.TemporaryDirectory() as tmpdir:
            editor_file = os.path.join(tmpdir, 'equation.txt')

            # Write the initial state for Neovim
            with open(editor_file, 'w') as f:
                f.write(f'FONTSIZE="{font_size}"\n')
                f.write('---\n')
                f.write(latex_code)

            # 3. Launch Neovim in a terminal (this blocks until Neovim is closed)
            cmd = TERMINAL_CMD + [EDITOR_CMD, editor_file]
            try:
                subprocess.run(
                    cmd,
                    check=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL
                )
            except Exception as e:
                inkex.errormsg(f"Failed to open terminal/editor: {e}")
                return

            # 4. Read the edited file back
            if not os.path.exists(editor_file):
                return  # User probably aborted or deleted the file

            with open(editor_file, 'r') as f:
                content = f.read()

            # Parse FONTSIZE and the actual LaTeX code
            parts = content.split('---', 1)
            if len(parts) == 2:
                header = parts[0]
                latex_code = parts[1].strip()

                # Extract fontsize using regex
                match = re.search(r'FONTSIZE\s*=\s*["\']([^"\']+)["\']', header)
                if match:
                    font_size = match.group(1)
            else:
                latex_code = content.strip()

            if not latex_code:
                return  # Nothing to render

            # 5. Create the TeX document
            tex_file = os.path.join(tmpdir, 'doc.tex')
            tex_template = f"""
\\documentclass{{article}}
\\usepackage{{lmodern}}
\\usepackage{{amsmath}}
\\usepackage{{amssymb}}
\\usepackage{{scrextend}}
\\changefontsizes{{{font_size}}}
\\usepackage{{exscale}}
\\usepackage{{relsize}}
\\usepackage{{cool}}
\\usepackage{{xparse}}
\\usepackage{{bm}}
\\usepackage[active,tightpage]{{preview}}
\\PreviewEnvironment{{equation*}}
\\setlength{{\\textwidth}}{{100cm}}
\\setlength{{\\paperwidth}}{{100cm}}

% Save the original cool derivatives if you ever need them
\\let\\CoolD\\D
\\let\\CoolDt\\Dt

\\RenewDocumentCommand{{\\D}}{{ m g }}{{%
    \\IfNoValueTF{{#2}}
        {{\\frac{{\\partial}}{{\\partial #1}}}}%
        {{\\frac{{\\partial #1}}{{\\partial #2}}}}%
}}

\\NewDocumentCommand{{\\Dt}}{{ m g }}{{%
  \\IfNoValueTF{{#2}}
    {{\\frac{{d}}{{d #1}}}}%
    {{\\frac{{d #1}}{{d #2}}}}%
}}

\\begin{{document}}
\\begin{{equation*}}
\\displaystyle
{latex_code}
\\end{{equation*}}
\\end{{document}}
"""
            with open(tex_file, 'w') as f:
                f.write(tex_template)

            # 6. Compile: tex -> pdf -> svg
            try:
                subprocess.run(
                    ['pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'doc.tex'],
                    cwd=tmpdir, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True
                )
            except subprocess.CalledProcessError:
                inkex.errormsg("LaTeX compilation failed. Check your equation syntax.")
                return

            try:
                subprocess.run(
                    ['pdftocairo', '-svg', 'doc.pdf', 'doc.svg'],
                    cwd=tmpdir, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True
                )
            except subprocess.CalledProcessError:
                inkex.errormsg("SVG conversion failed (pdftocairo error).")
                return

            # 7. Import the SVG back into Inkscape
            svg_file = os.path.join(tmpdir, 'doc.svg')
            with open(svg_file, 'r') as f:
                svg_str = f.read()

            # Prefix all IDs with a unique token to avoid collisions
            # when multiple equations are inserted into the same document.
            uid = uuid.uuid4().hex[:8]
            svg_str = prefix_ids(svg_str, uid)
            compiled_svg = etree.fromstring(svg_str.encode())

            # pdftocairo outputs in pt (1/72 inch).
            # Inkscape's document is in mm, so we scale by 25.4/72.
            scale = 25.4 / 72.0

            # Move <defs> contents into the document's <defs>
            svg_defs = compiled_svg.find('{http://www.w3.org/2000/svg}defs')
            if svg_defs is not None:
                doc_defs = self.svg.defs
                for child in svg_defs:
                    doc_defs.append(child)

            # Wrap remaining non-defs elements in a scaled group
            content_group = inkex.Group()
            content_group.set('transform', f'scale({scale})')
            for elem in compiled_svg:
                tag = etree.QName(elem.tag).localname if isinstance(elem.tag, str) else None
                if tag and tag != 'defs':
                    content_group.append(elem)

            new_group = inkex.Group()
            new_group.append(content_group)
            new_group.set('data-latex-code', latex_code)
            new_group.set('data-font-size', font_size)

            # 8. Insert or Replace
            if selected_node is not None:
                # Retain the position/transform of the old object
                if selected_node.get('transform'):
                    new_group.set('transform', selected_node.get('transform'))
                parent = selected_node.getparent()
                parent.replace(selected_node, new_group)
            else:
                # Insert at the top-left of the current layer (0,0)
                self.svg.get_current_layer().append(new_group)

if __name__ == '__main__':
    NeovimLatex().run()
