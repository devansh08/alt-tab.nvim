local M = {}

function M.setup()
  ---@type number|nil
  local lastTab = nil
  ---@type boolean
  local ignoreNext = false

  ---@type number
  local group = vim.api.nvim_create_augroup("alt-tab.nvim", { clear = true })

  vim.api.nvim_create_autocmd("TabLeave", {
    group = group,
    callback = function()
      if not ignoreNext then
        lastTab = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
      else
        ignoreNext = false
      end
    end,
  })

  vim.api.nvim_create_user_command("AltTab", function()
    if lastTab and lastTab ~= vim.api.nvim_tabpage_get_number(0) then
      ignoreNext = true
      ---@type number
      local tempTab = lastTab
      lastTab = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
      vim.cmd("tabnext " .. tempTab)
    end
  end, {})
end

return M
