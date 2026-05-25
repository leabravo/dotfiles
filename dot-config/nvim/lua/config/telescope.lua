local pins = require('pins')
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

telescope.setup({})
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fr', builtin.live_grep, { desc = 'Telescope live ripgrep' })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Telescope find git' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "<leader>fp", function()
  local results = {}

  for i, file in pairs(pins.data) do
    table.insert(results, { index = i, file = file })
  end

  table.sort(results, function(a, b)
    return a.index < b.index
  end)

  require("telescope.pickers").new(
    themes.get_dropdown({
        previewer = false,
        prompt_title = "Pins",
    }), {
    finder = require("telescope.finders").new_table({
      results = results,
      entry_maker = function(e)
        return {
          value = e.file,
          display = string.format("[%d] %s", e.index, vim.fn.fnamemodify(e.file, ":.")),
          ordinal = e.index .. " " .. e.file,
          filename = e.file,
        }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
  }):find()
end)
