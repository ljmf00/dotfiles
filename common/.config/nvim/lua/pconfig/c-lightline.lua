vim.g['lightline'] = {
      colorscheme = 'sonokai',
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
