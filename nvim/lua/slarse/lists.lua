local function get_zero_indexed_row(win)
  return vim.api.nvim_win_get_cursor(win)[1] - 1
end

local function get_file_indent()
  local tabstop = vim.api.nvim_get_option_value("tabstop", {})
  local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", {})
  local expandtab = vim.api.nvim_get_option_value("expandtab", {})

  if expandtab then
    return string.rep(" ", shiftwidth)
  else
    local num_tabs = math.max(1, math.floor(shiftwidth / tabstop))
    return string.rep("\t", num_tabs)
  end
end

local function get_line_indent_level()
  local file_indent = get_file_indent()
  local line = vim.api.nvim_get_current_line()

  local line_indent = string.match(line, "^" .. file_indent .. "*")

  return math.floor(string.len(line_indent) / string.len(file_indent))
end

local list_start_token_to_end_token = {
  ["{"] = "}",
  ["("] = ")",
  ["["] = "]",
}

local function get_list_from_node(node)
  local children = node:iter_children()
  local first_child = children()
  if first_child == nil then
    vim.notify("Could not find first child, are you selecting something reasonable?")
    return nil, nil, nil
  end

  local list_start_token = vim.treesitter.get_node_text(first_child, 0)
  local list_end_token = list_start_token_to_end_token[list_start_token]
  if list_end_token == nil then
    vim.notify("Unknown list start token " .. list_start_token)
    return nil, nil, nil
  end

  local replacement = {}

  while true do
    local child = children()
    if child == nil then
      break
    end

    local text = vim.treesitter.get_node_text(child, 0)
    if text == list_end_token then
      break
    end

    table.insert(replacement, text)

    -- skip list separator
    children()
  end

  return replacement, list_start_token, list_end_token
end

local function list_expand_lines()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify("No node under cursor ...")
    return
  end

  local file_indent = get_file_indent()
  local line_indent_level = get_line_indent_level()
  local line_indent = string.rep(file_indent, line_indent_level)
  local list_item_indent = string.rep(file_indent, line_indent_level + 1)

  local list_items, list_start_token, list_end_token = get_list_from_node(node)
  if list_items == nil or list_start_token == nil or list_end_token == nil then
    return
  end

  local replacement = {list_start_token}

  for _, item in ipairs(list_items) do
    table.insert(replacement, list_item_indent .. item .. ",")
  end

  table.insert(replacement, line_indent .. list_end_token)

  local start_row, start_col = node:start()
  local end_row, end_col = node:end_()

  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, replacement)
end

local function list_contract_lines()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify("No node under cursor ...")
    return
  end

  local list_items, list_start_token, list_end_token = get_list_from_node(node)
  if list_items == nil or list_start_token == nil or list_end_token == nil then
    return
  end

  local replacement = {list_start_token}
  for i, item in ipairs(list_items) do
    table.insert(replacement, item)

    if list_items[i + 1] ~= nil then
      table.insert(replacement, ", ")
    end
  end

  table.insert(replacement, list_end_token)

  local start_row, start_col = node:start()
  local end_row, end_col = node:end_()
  local replacement_text = table.concat(replacement)

  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {replacement_text})
end

vim.api.nvim_create_user_command("ListExpandLines", list_expand_lines, {})
vim.api.nvim_create_user_command("ListContractLines", list_contract_lines, {})
