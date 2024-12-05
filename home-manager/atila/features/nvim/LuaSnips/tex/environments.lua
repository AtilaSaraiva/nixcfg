local in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

return {
    -- The same equation snippet, using LuaSnip's fmt function.
    -- The snippet is not shorter, but it is more *human-readable*.
    s({trig="nk", dscr="A LaTeX equation environment", snippetType="autosnippet"},
      fmt( -- The snippet code actually looks like the equation environment it produces.
        [[
          \begin{equation}
              <>,
          \end{equation}
        ]],
        -- The insert node is placed in the <> angle brackets
        { i(1) },
        -- This is where I specify that angle brackets are used as node positions.
        { delimiters = "<>" }
      )
    ),
    s(
        {trig="dk", dscr="display mode equation", snippetType="autosnippet"},
        fmta(
            [[
                \[
                    <>,
                \]
            ]],
            { i(1) }
        )
    ),
    s(
        {trig="mk", dscr="inline mode equation", snippetType="autosnippet"},
        fmta(
            [[
                $<>$
            ]],
            { i(1) }
        )
    ),
    s({trig="env", dscr="creates custom env"},
        fmta(
           [[
               \begin{<>}
                   <>
               \end{<>}
           ]],

           { i(1), i(2), rep(1) }
        )
    ),
    s({trig="fig", dscr="figure env"},
        fmta(
           [[
               \begin{figure}[<>]
                   \centering
                   \includegraphics[width=0.8\textwidth]{<>}
                   \caption{<>}
                   \label{fig:<>}
               \end{figure}
           ]],
           {
               i(1, "h"),
               i(2),
               i(3),
               i(4)
           }
        )
    ),
    s({trig="enum", dscr="enumerate env"},
        fmta(
           [[
               \begin{enumerate}
                   \item <>
               \end{enumerate}
           ]],
           { i(1) }
        )
    ),
    s({trig="item", dscr="itemize env"},
        fmta(
           [[
               \begin{itemize}
                   \item <>
               \end{itemize}
           ]],
           { i(1) }
        )
    ),
    s({trig="align", dscr="align env"},
        fmta(
           [[
               \begin{align}
                   <>
               \end{align}
           ]],
           { i(1) }
        )
    ),
}
