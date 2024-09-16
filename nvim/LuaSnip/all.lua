return {
	s(
		{ trig = "email", snippetType = "snippet", descr = "Outline for an email address" },
		fmt([[ {}@{}.{} ]], { i(1, "local"), i(2, "subdomain"), i(3, "tld") })
	),
	s(
		{ trig = "emailc", snippetType = "autosnippet", descr = "Outline for an email address" },
		fmt([[ {}@{}.com ]], { i(1, "local"), i(2, "subdomain") })
	),
	s(
		{ trig = "emailse", snippetType = "autosnippet", descr = "Outline for an email address" },
		fmt([[ {}@{}.se ]], { i(1, "local"), i(2, "subdomain") })
	),
}
