local function pg_log_bind_parameters()
	local statement_line_nr = vim.api.nvim_win_get_cursor(0)[1]
	local parameters_line_nr = statement_line_nr + 1

	local lines = vim.api.nvim_buf_get_lines(0, statement_line_nr - 1, parameters_line_nr, false)

	local statement_line = lines[1]
	local parameters_line = lines[2]

	local _, statement_start = string.find(statement_line, "execute .-:")
	if statement_start == nil then
		vim.print("No statement found")
		return
	end

	local _, parameter_list_start = string.find(parameters_line, "parameters: ")
	if parameter_list_start == nil then
		vim.print("No parameters found")
		return
	end

	statement_start = statement_start + 2
	parameter_list_start = parameter_list_start + 1

	local statement = string.sub(statement_line, statement_start)

	local raw_parameters = vim.split(string.sub(parameters_line, parameter_list_start), ", ")

	for _, placeholder_and_parameter in ipairs(raw_parameters) do
		local placeholder_end = string.find(placeholder_and_parameter, " ")
		local parameter = string.sub(placeholder_and_parameter, placeholder_end + #" = ")
		local placeholder = string.sub(placeholder_and_parameter, 1, placeholder_end - 1)

		statement = string.gsub(statement, "%" .. placeholder, parameter)
	end

	statement = statement .. ";"
	vim.api.nvim_buf_set_lines(0, statement_line_nr - 1, parameters_line_nr, false, { statement })
end

vim.api.nvim_create_user_command("PgLogBindParameters", pg_log_bind_parameters, {})
