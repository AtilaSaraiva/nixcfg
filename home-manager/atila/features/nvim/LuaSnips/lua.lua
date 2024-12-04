return {
    s({trig="snip", dscr="A snippet to create snippets"},
        fmta(
            [=[
                s({trig="<>", dscr="<>"},
                    fmta(
                       [[
                           <>
                       ]],
                       { i(1)<> }
                    )
                ),
            ]=],
            { i(1), i(2), i(3), i(4) }
        )
    ),
    s({trig="asnip", dscr="A snippet to create auto snippets"},
        fmta(
            [=[
                s({trig="<>", dscr="<>", snippetType="autosnippet"},
                    fmta(
                       [[
                           <>
                       ]],
                       { i(1)<> }
                    )
                ),
            ]=],
            { i(1), i(2), i(3), i(4) }
        )
    ),
    -- Example: italic font implementing visual selection
    s({trig="dsnip", dscr="A snippet to create dynamic snippets"},
        fmta(
            [=[
                s({trig = "<>", dscr = "<>"},
                    fmta("<>",
                        {
                            d(1, get_visual),<>
                        }
                    )
                )
            ]=],
            { i(1), i(2), i(3), i(4) }
        )
    ),
}
