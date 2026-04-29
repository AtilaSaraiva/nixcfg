#!/usr/bin/env python3
import inkex
import os
import subprocess
import tempfile
import re
import pathlib
from lxml import etree

# --- CONFIGURATION ---
# Change this to match your terminal. 
# e.g., ['kitty', '--'] or ['alacritty', '-e'] or ['x-terminal-emulator', '-e']
TERMINAL_CMD = ['kitty', '--'] 
EDITOR_CMD = 'nvim'
# ---------------------

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
                return # User probably aborted or deleted the file
                
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
                return # Nothing to render

            # 5. Create the TeX document
            tex_file = os.path.join(tmpdir, 'doc.tex')
            tex_template = f"""
\\documentclass{{standalone}}
\\usepackage{{lmodern}}
\\usepackage{{amsmath}}
\\usepackage{{amssymb}}
\\usepackage{{scrextend}}
\\changefontsizes{{{font_size}}}
\\usepackage{{cool}}
\\usepackage{{xparse}}
\\usepackage{{bm}}

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
$\\displaystyle {latex_code} $
\\end{{document}}
"""
            with open(tex_file, 'w') as f:
                f.write(tex_template)

            # 6. Compile: tex -> pdf -> svg
            try:
                subprocess.run(
                    ['pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'doc.tex'],
                    cwd=tmpdir, stdout=subprocess.DEVNULL, check=True
                )
                subprocess.run(
                    ['pdftocairo', '-svg', 'doc.pdf', 'doc.svg'],
                    cwd=tmpdir, stdout=subprocess.DEVNULL, check=True
                )
            except subprocess.CalledProcessError:
                inkex.errormsg("LaTeX compilation failed. Check your syntax.")
                return

            # 7. Import the SVG back into Inkscape
            svg_file = os.path.join(tmpdir, 'doc.svg')
            with open(svg_file, 'rb') as f:
                compiled_svg = etree.parse(f).getroot()

            # Inkscape's PDF->SVG export gives us a clean, correctly scaled SVG.
            # We just need to grab the contents and wrap them in a group.
            new_group = inkex.Group()
            for elem in compiled_svg:
                if isinstance(elem, etree._Element):
                    new_group.append(elem)

            # Store the data so we can edit it later
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
