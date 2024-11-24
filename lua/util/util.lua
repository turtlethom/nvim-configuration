local Util = {}

Util.colors = {
	red = "#ff0000",
	green = "#00ff00",
	blue = "#0000ff",
	yellow = "#ffff00",
	cyan = "#00ffff",
	magenta = "#ff00ff",
	orange = "#ffa500",
	pink = "#ffc0cb",
	white = "#ffffff",
	neonpink = "#FF0080",
}

Util.apply_random_highlights = function()
	local highlights = {}

	-- Generate random highlight colors
	for i = 1, 10 do
		local color = string.format("#%06x", math.random(0, 0xFFFFFF))
		local group_name = "RandomHighlight" .. i
		vim.api.nvim_set_hl(0, group_name, { fg = color }) -- define highlight
		table.insert(highlights, group_name)
	end
end

return Util
