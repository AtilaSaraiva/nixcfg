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

local in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

return {
    s({trig="tt", dscr="Expands 'tt' into '\texttt{}'"},
        {
            t("\\texttt{"), -- remember: backslashes need to be escaped
            i(1),
            t("}"),
        }
    ),
    s({trig="hr", dscr="The hyperref package's href{}{} command (for url links)"},
        fmta(
            [[\href{<>}{<>}]],
            {
                i(1, "url"),
                i(2, "display name"),
            }
        )
    ),
    -- Example: italic font implementing visual selection
    s({trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command."},
        fmta("\\textit{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    s({trig = "tbb", dscr = "Expands 'tbb' into LaTeX's \\textbf{} command."},
        fmta("\\textbf{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    s({trig = "tuu", dscr = "Expands 'tuu' into LaTeX's \\underline{} command."},
        fmta("\\underline{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    s({trig = "tsc", dscr = "Expands 'tsc' into LaTeX's \\textsc{} command."},
        fmta("\\textsc{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    s({trig = "ttt", dscr = "Expands 'ttt' into LaTeX's \\texttt{} command."},
        fmta("\\texttt{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    s({trig = "tll", dscr = "Expands 'tll' into LaTeX's \\large{} command."},
        fmta("{\\large <>}",
            {
                d(1, get_visual),
            }
        )
    ),
}
