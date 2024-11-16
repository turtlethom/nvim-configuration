local Module = {}
function Module.safe_command_output(command, fallback)
	local handle = io.popen(command)
	local result = handle and handle:read("*a")
	if handle then
		handle:close()
	end

	return (result and result ~= "") and result or fallback
end

return Module
