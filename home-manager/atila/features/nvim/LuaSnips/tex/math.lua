-- This is the `get_visual` function I've been talking about.
-- ----------------------------------------------------------------------------
-- Summary: When `LS_SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {
    s({trig="ff", dscr="Expands 'ff' into fraction", snippetType="autosnippet"},
        fmta(
            "\\frac{<>}{<>}",
            {
                d(1, get_visual),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = 'ee', dscr="exponential", snippetType="autosnippet"},
        fmta(
            "e^{<>}",
            {
                d(1, get_visual)
            }
        ),
        { condition = in_mathzone }
    ),
    -- A fun zero subscript snippet
    s({trig = '([%a%)%]%}])(%d)', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>_<>",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end ),
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = '([%a%)%]%}])_(%a%a)', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>_{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end ),
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = '([%a%)%]%}])__', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>_{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = '([%a])/', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\frac{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = '%((.-)%)/', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\frac{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig="=>", dscr="imply", snippetType="autosnippet"},
        t("\\imply"),
        { condition = in_mathzone }
    ),
    s({trig="<=", dscr="imply", snippetType="autosnippet"},
        t("\\impliedby"),
        { condition = in_mathzone }
    ),
    s({trig="iff", dscr="if and only if", snippetType="autosnippet"},
        t("\\iff"),
        { condition = in_mathzone }
    ),
    s({trig="==", dscr="equal sign", snippetType="autosnippet"},
        t("&="),
        { condition = in_mathzone }
    ),
    s({trig="!=", dscr="not equal sign", snippetType="autosnippet"},
        t("\\neq"),
        { condition = in_mathzone }
    ),

    -- Ceiling function
    s({trig = "ceil", dscr = "Left ceil and right ceil", snippetType = "autosnippet"},
        fmta("\\left\\lceil <> \\right\\rceil", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Floor function
    s({trig = "floor", dscr = "Left floor and right floor", snippetType = "autosnippet"},
        fmta("\\left\\lfloor <> \\right\\rfloor", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Parentheses matrix
    s({trig = "pmat", dscr = "Parentheses matrix", snippetType = "autosnippet"},
        fmta("\\begin{pmatrix} <> \\end{pmatrix}", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Brackets matrix
    s({trig = "bmat", dscr = "Brackets matrix", snippetType = "autosnippet"},
        fmta("\\begin{bmatrix} <> \\end{bmatrix}", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Dots
    s({trig = "...", dscr = "Ellipsis for math", priority = 1000, snippetType = "autosnippet"},
        t("\\cdots"),
        { condition = in_mathzone }
    ),

    -- Left and right parentheses
    s({trig = "%(%(", dscr = "Left and right parentheses", regTrig = true, snippetType = "autosnippet"},
        fmta("\\left( <> \\right)", { d(1, get_visual) }),
        { condition = in_mathzone }
    ),

    -- Left and right absolute value
    s({trig = "rr|", dscr = "Left and right absolute value with subscript", snippetType = "autosnippet"},
        fmta("\\left. <> \\right|_{<>}", { d(1, get_visual), i(2) }),
        { condition = in_mathzone }
    ),

    -- Matching parentheses
    s({trig = "lr", dscr = "Left and right parentheses"},
        fmta("\\left( <> \\right)", { d(1, get_visual) })
    ),

    -- Left and right curly braces
    s({trig = "lr{", dscr = "Left and right curly braces"},
        fmta("\\left\\{ <> \\right\\}", { d(1, get_visual) })
    ),

    -- Left and right brackets
    s({trig = "lr[", dscr = "Left and right brackets"},
        fmta("\\left[ <> \\right]", { d(1, get_visual) })
    ),

    -- Left and right double vertical bars
    s({trig = "lrp", dscr = "Left and right double vertical bars"},
        fmta("\\left\\| <> \\right\\|", { d(1, get_visual) })
    ),

    -- Left and right angle brackets
    s({trig = "lra", dscr = "Left and right angle brackets"},
        fmta("\\left<< <> \\right>>", { d(1, get_visual) })
    ),

    -- Conjugate
    s({trig = "conj", dscr = "Conjugate", snippetType = "autosnippet"},
        fmta("\\overline{<>}", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Summation
    s({trig = "sum", dscr = "Summation from n=1 to N", wordTrig = true},
        fmta("\\sum_{i=<>}^{<>} <>", { i(1, "1"), i(2, "N"), i(3) }),
        { condition = in_mathzone }
    ),

    -- Limit
    s({trig = "lim", dscr = "Limit expression", wordTrig = true, snippetType = "autosnippet"},
        fmta("\\lim_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }),
        { condition = in_mathzone }
    ),

    -- Product
    s({trig = "prod", dscr = "Product expression", wordTrig = true, snippetType = "autosnippet"},
        fmta("\\prod_{<>}^{<>} <>", { 
            fmta("n=<>", { i(1, "1") }),
            i(2, "\\infty"),
            i(3) 
        }),
        { condition = in_mathzone }
    ),

    -- Partial derivative
    s({trig = "part", dscr = "Partial derivative", wordTrig = true, snippetType = "autosnippet"},
        fmta("\\frac{\\partial <>}{\\partial <>}", { i(1, "u"), i(2, "x") }),
        { condition = in_mathzone }
    ),

    -- Einstein derivative notation
    s({trig = "eins", dscr = "Einstein derivative notation", wordTrig = true, snippetType = "autosnippet"},
        fmta("\\partial_{<>} <>", { i(1, "x"), i(2, "u") }),
        { condition = in_mathzone }
    ),

    -- Square root
    s({trig = "sq", dscr = "Square root", snippetType = "autosnippet"},
        fmta("\\sqrt{<>}", { d(1, get_visual) }),
        { condition = in_mathzone }
    ),

    -- Superscript 2
    s({trig = "sr", dscr = "Superscript 2", snippetType = "autosnippet"},
        t("^2"),
        { condition = in_mathzone }
    ),

    -- Superscript 3
    s({trig = "cb", dscr = "Superscript 3", snippetType = "autosnippet"},
        t("^3"),
        { condition = in_mathzone }
    ),

    -- General superscript
    s({trig = "td", dscr = "General superscript", snippetType = "autosnippet"},
        fmta("^{<>}", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Parenthesized superscript
    s({trig = "rd", dscr = "Parenthesized superscript", snippetType = "autosnippet"},
        fmta("^{(<>)}", { i(1) }),
        { condition = in_mathzone }
    ),

    -- Infinity
    s({trig = "ooo", dscr = "Infinity symbol", snippetType = "autosnippet"},
        t("\\infty"),
        { condition = in_mathzone }
    ),

    -- Less than or equal to
    s({trig = "<=", dscr = "Less than or equal to", snippetType = "autosnippet"},
        t("\\le"),
        { condition = in_mathzone }
    ),

    -- Greater than or equal to
    s({trig = ">=", dscr = "Greater than or equal to", snippetType = "autosnippet"},
        t("\\ge"),
        { condition = in_mathzone }
    ),

    -- Exists
    s({trig = "EE", dscr = "Exists quantifier", snippetType = "autosnippet"},
        t("\\exists"),
        { condition = in_mathzone }
    ),

    -- For all
    s({trig = "AA", dscr = "For all quantifier", snippetType = "autosnippet"},
        t("\\forall"),
        { condition = in_mathzone }
    ),

    -- Mathcal
    s({trig = "mcal", dscr = "Mathcal for calligraphic font", snippetType = "autosnippet"},
        fmta("\\mathcal{<>} <>", { i(1), i(0) }),
        { condition = in_mathzone }
    ),

    -- Nabla
    s({trig = "nabl", dscr = "Nabla symbol", snippetType = "autosnippet"},
        t("\\nabla"),
        { condition = in_mathzone }
    ),

    -- Cross product
    s({trig = "xx", dscr = "Cross product", snippetType = "autosnippet"},
        t("\\times"),
        { condition = in_mathzone }
    ),

    -- Dot product (cdot)
    s({trig = "**", dscr = "Dot product (cdot)", snippetType = "autosnippet", priority = 100},
        t("\\cdot"),
        { condition = in_mathzone }
    ),

    -- Norm
    s({trig = "norm", dscr = "Norm with subscript", snippetType = "autosnippet"},
        fmta("\\|<>\\|_{<>} <>", { i(1), i(2), i(0) }),
        { condition = in_mathzone }
    ),

    -- Arrow (to)
    s({trig = "->", dscr = "To arrow", snippetType = "autosnippet", priority = 100},
        t("\\to"),
        { condition = in_mathzone }
    ),

    -- Left-Right Arrow (leftrightarrow)
    s({trig = "<->", dscr = "Left-right arrow", snippetType = "autosnippet", priority = 200},
        t("\\leftrightarrow"),
        { condition = in_mathzone }
    ),

    -- Mapsto
    s({trig = "!>", dscr = "Mapsto symbol", snippetType = "autosnippet"},
        t("\\mapsto"),
        { condition = in_mathzone }
    ),

    -- Inverse (^-1)
    s({trig = "inv", dscr = "Inverse symbol", snippetType = "autosnippet"},
        t("^{-1}"),
        { condition = in_mathzone }
    ),

    -- Greater-than-greater-than (gg)
    s({trig = ">>", dscr = "Greater-than-greater-than symbol", snippetType = "autosnippet"},
        t("\\gg"),
        { condition = in_mathzone }
    ),

    -- Less-than-less-than (ll)
    s({trig = "<<", dscr = "Less-than-less-than symbol", snippetType = "autosnippet"},
        t("\\ll"),
        { condition = in_mathzone }
    ),

    -- Tilde (sim)
    s({trig = "~~", dscr = "Tilde symbol", snippetType = "autosnippet"},
        t("\\sim"),
        { condition = in_mathzone }
    ),

    -- Set notation
    s({trig = "set", dscr = "Set notation", snippetType = "autosnippet", wordTrig = true},
        fmta("\\{<>\\} <>", { i(1), i(0) }),
        { condition = in_mathzone }
    ),

    -- Mid (mid)
    s({trig = "||", dscr = "Mid symbol", snippetType = "autosnippet"},
        t("\\mid"),
        { condition = in_mathzone }
    ),

    -- Subset (subset)
    s({trig = "cc", dscr = "Subset symbol", snippetType = "autosnippet"},
        t("\\subset"),
        { condition = in_mathzone }
    ),

    -- Subset or equal (subseteq)
    s({trig = "ec", dscr = "Subset or equal symbol", snippetType = "autosnippet"},
        t("\\subseteq"),
        { condition = in_mathzone }
    ),

    -- Not in (notin)
    s({trig = "notin", dscr = "Not in symbol", snippetType = "autosnippet"},
        t("\\not\\in"),
        { condition = in_mathzone }
    ),

    -- In (in)
    s({trig = "inn", dscr = "In symbol", snippetType = "autosnippet"},
        t("\\in"),
        { condition = in_mathzone }
    ),

    -- N (set of natural numbers)
    s({trig = "NN", dscr = "Natural numbers symbol", snippetType = "autosnippet"},
        t("\\N"),
        { condition = in_mathzone }
    ),

    -- Cap (intersection)
    s({trig = "Nn", dscr = "Intersection (cap)", snippetType = "autosnippet"},
        t("\\cap"),
        { condition = in_mathzone }
    ),

    -- Cup (union)
    s({trig = "UU", dscr = "Union (cup)", snippetType = "autosnippet"},
        t("\\cup"),
        { condition = in_mathzone }
    ),

    -- Text subscript
    s({trig = '([%a%)%]%}])%"', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>_{\\text{<>}}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig = '%((.-)%)bar', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\overline{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
            }
        ),
        { condition = in_mathzone }
    ),
    s({trig="([%a])hat", dscr="hat", snippetType="autosnippet", regTrig = true,
       wordTrig = false},
        fmta("\\hat{<>}",
           { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),
    s({trig="([%a])bf", dscr="hat", snippetType="autosnippet", regTrig = true,
       wordTrig = false},
        fmta("\\mathbf{<>}",
           { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),
    s({trig="([^%a])hat", dscr="hat", snippetType="autosnippet", regTrig = true,
       wordTrig = false},
        fmta("<>\\hat{<>}",
           { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ),
        { condition = in_mathzone }
    ),
    s({trig="([^%a])bf", dscr="bf", snippetType="autosnippet", regTrig = true,
       wordTrig = false},
        fmta("<>\\mathbf{<>}",
           { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ),
        { condition = in_mathzone }
    ),
    s({trig="RR", dscr="Real", snippetType="autosnippet"},
        t("\\mathbb{R}"),
        { condition = in_mathzone }
    ),
    
    s( -- This snippets creates the sympy block ;)
        { trig = "sym", dscr = "Creates a sympy block", snippetType="autosnippet" },
        fmt("sympy {} sympy{}",
            { i(1), i(0) }
        ),
        { condition = in_mathzone }
    ),

    s( -- This one evaluates anything inside the simpy block
        { trig = "sympy.*sympy", regTrig = true, desc = "Sympy block evaluator" },
        d(1, function(_, parent)
            -- Gets the part of the block we actually want, and replaces spaces
            -- at the beginning and at the end
            local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympy", "%1")
            to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

            local Job = require("plenary.job")

            local sympy_script = string.format(
                [[
                    from sympy import *
                    from sympy.parsing.sympy_parser import parse_expr
                    from sympy.printing.latex import print_latex
                    parsed = parse_expr('%s')
                    print_latex(parsed)
                ]],
                to_eval
            )

            sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
            local result = ""

            Job:new({
                command = "python",
                args = {
                    "-c",
                    sympy_script,
                },
                on_exit = function(j)
                    result = j:result()
                end,
            }):sync()

            return sn(nil, t(result))
        end),
        { condition = in_mathzone }
    )
}
