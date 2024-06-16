local options = {
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
    hide_root_folder = false,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
      quit_on_open = true,
    },
  },
  renderer = {
    root_folder_label = true,
    highlight_git = true,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "F",
        symlink = "S",
        folder = {
          default = "D",
          open = "D",
          empty = "E",
          empty_open = "E",
          symlink = "S",
          symlink_open = "S",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "*",
          staged = "+",
          unmerged = "%",
          renamed = ">",
          untracked = "?",
          deleted = "-",
          ignored = "!",
        },
      },
    },
  },
}

return options
