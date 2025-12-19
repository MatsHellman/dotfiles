return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files' },
    { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Live grep' },
    { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Help tags' },
  },
}

