-- get_short_path.lua
-- Shorten and format the current buffer path for display in the winbar.
return function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path == "" then
    return "" -- Jika buffer kosong, tidak tampilkan apa-apa
  end

  local home = vim.fn.expand "$HOME"
  local project_home = home .. "/proyek"

  if buf_path:find("^" .. vim.pesc(project_home)) then
    buf_path = buf_path:gsub("^" .. vim.pesc(project_home) .. "/", "")
  elseif buf_path:find("^" .. vim.pesc(home)) then
    buf_path = buf_path:gsub("^" .. vim.pesc(home) .. "/", "")
  end

  local display_path1 = buf_path:gsub("//", "/")
  local display_path = display_path1:gsub("/", " -> ")

  return "%#MiniIconsPurple#  LitFill :: " .. display_path
end
