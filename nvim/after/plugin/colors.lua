function Colorize(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)
end

Colorize()
