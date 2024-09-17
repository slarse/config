return {
	s(
		{ trig = "iferr", snippetType = "autosnippet", dscr = "if err != nil block" },
		fmta(
			[[
      if err != nil {
      	<>
      }
    ]],
			{ i(1) }
		)
	),
	s(
		{ trig = "vardd", snippetType = "autosnippet", dscr = "variable declaration and assignment" },
		fmt(
			[[
      var {} {} = {}
      ]],
			{ i(1, "name"), i(2, "type"), i(3, "value") }
		)
	),
	s(
		{ trig = "vardi", snippetType = "autosnippet", dscr = "variable declaration and assignment with inference" },
		fmt(
			[[
      {} := {}
      ]],
			{ i(1, "name"), i(2, "value") }
		)
	),
	s(
		{ trig = "varde", snippetType = "autosnippet", dscr = "variable declaration and assignment with inference" },
		fmt(
			[[
      {}, err := {}
      ]],
			{ i(1, "name"), i(2, "value") }
		)
	),
	s(
		{ trig = "sfi", snippetType = "autosnippet", dscr = "struct field definition" },
		fmt(
			[[
      {} {}
      ]],
			{ i(1, "name"), i(2, "type") }
		)
	),
	s(
		{ trig = "tsfi", snippetType = "autosnippet", dscr = "struct field definition with tag" },
		fmt(
			[[
      {} {} `{}`
      ]],
			{ i(1, "name"), i(2, "type"), i(3, "tag") }
		)
	),
	s(
		{ trig = "jsfi", snippetType = "autosnippet", dscr = "struct field definition with JSON tag" },
		fmt(
			[[
      {} {} `json:"{}"`
      ]],
			{ i(1, "name"), i(2, "type"), i(3, "tag") }
		)
	),
}
