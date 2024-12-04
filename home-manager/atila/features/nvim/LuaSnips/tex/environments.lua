-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

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
}
