vim.g['lightline'] = {
      colorscheme = 'Tomorrow_Night_Eighties',
      active = {
            left = {
                  { 'mode', 'paste' },
                  { 'gitbranch', 'readonly', 'filename', 'modified' }
            }
      },
      component_function = {
        gitbranch = 'FugitiveHead'
      },
}
