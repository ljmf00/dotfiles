vim.g['lightline'] = {
      colorscheme = 'simple',
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
