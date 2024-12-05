return {
    s({trig="template", dscr="The basic main template"},
        fmta(
           [[
                \documentclass[a4paper]{article}

                \usepackage[utf8]{inputenc}
                \usepackage[T1]{fontenc}
                \usepackage{textcomp}
                \usepackage[english]{babel}
                \usepackage{amsmath, amssymb}


                % figure support
                \usepackage{import}
                \usepackage{xifthen}
                \pdfminorversion=7
                \usepackage{pdfpages}
                \usepackage{transparent}
                \newcommand{\incfig}[1]{%
                    \def\svgwidth{\columnwidth}
                    \import{./figures/}{#1.pdf_tex}
                }

                \newcommand{\R}{\ensuremath{\mathbb{R}}}

                \pdfsuppresswarningpagegroup=1

                \begin{document}
                    <>
                \end{document}
           ]],
           { i(0) }
        )
    ),
    s({trig="bibtemplate", dscr="The basic main template with bibliography"},
        fmta(
           [[
                \documentclass[a4paper]{article}

                \usepackage[utf8]{inputenc}
                \usepackage[T1]{fontenc}
                \usepackage{textcomp}
                \usepackage[english]{babel}
                \usepackage{amsmath, amssymb}

                % figure support
                \usepackage{import}
                \usepackage{xifthen}
                \pdfminorversion=7
                \usepackage{pdfpages}
                \usepackage{transparent}
                \newcommand{\incfig}[1]{%
                    \def\svgwidth{\columnwidth}
                    \import{./figures/}{#1.pdf_tex}
                }

                \usepackage[style=authoryear,sorting=ynt]{biblatex}
                \addbibresource{references.bib}

                \newcommand{\R}{\ensuremath{\mathbb{R}}}

                \pdfsuppresswarningpagegroup=1

                \title{<>}
                \author{Átila Saraiva Quintela Soares}

                \begin{document}
                    \maketitle

                    <>

                    \printbibliography
                \end{document}
           ]],
           { i(1), i(0) }
        )
    ),
}
