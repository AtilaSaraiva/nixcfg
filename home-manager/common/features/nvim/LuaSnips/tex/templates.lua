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

                \usepackage{cool}
                \usepackage{xparse}

                % Save the original cool derivatives if you ever need them
                \let\CoolD\D
                \let\CoolDt\Dt

                \RenewDocumentCommand{\D}{ m g }{%
                    \IfNoValueTF{#2}
                        {\frac{\partial}{\partial #1}}%
                        {\frac{\partial #1}{\partial #2}}%
                }

                \NewDocumentCommand{\Dt}{ m g }{%
                  \IfNoValueTF{#2}
                    {\frac{d}{d #1}}%
                    {\frac{d #1}{d #2}}%
                }


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
                \usepackage{cool}
                \usepackage{xparse}

                % Save the original cool derivatives if you ever need them
                \let\CoolD\D
                \let\CoolDt\Dt

                \RenewDocumentCommand{\D}{ m g }{%
                    \IfNoValueTF{#2}
                        {\frac{\partial}{\partial #1}}%
                        {\frac{\partial #1}{\partial #2}}%
                }

                \NewDocumentCommand{\Dt}{ m g }{%
                  \IfNoValueTF{#2}
                    {\frac{d}{d #1}}%
                    {\frac{d #1}{d #2}}%
                }

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
