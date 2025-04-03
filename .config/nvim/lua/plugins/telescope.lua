local keymap = vim.keymap

local config = function()
    local telescope = require("telescope")
    telescope.setup({
        defaults= {
            mappings = {
                i = {
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k>"] = "move_selection_previous",
                }
            },
        },
        pickers = {
            find_files = {
                theme = "dropdown",
                previewer = true,
                hidden = true,
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        width = 0.8,
                        height = 0.7,
                        preview_width = 0.5,
                    }
                },
            },
            live_grep = {
                theme = "dropdown",
                previewer = true,

                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        width = 0.8,
                        height = 0.7,
                        preview_width = 0.5,
                    }
                },
                --mappings = {
                --    i = {
                --        ["C-Up"] = "preview_scrolling_up",
                --        ["C-Down"] = require("telescope.actions").preview_scrolling_down,
                --    },
                --    n = {
                --        ["C-Up"] = "preview_scrolling_up",
                --        ["C-Down"] = require("telescope.actions").preview_scrolling_down,
                --    },
                --}
            },
            find_buffers = {
                theme = "dropdown",
                previewer = false,
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        width = 0.8,
                        height = 0.7,
                        preview_width = 0.5,
                    }
                },
            },
            projects = {
                theme = "dropdown",
                previewer = "false",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        width = 0.8,
                        height = 0.7,
                        preview_width = 0.5,
                    }
                },
            }
        }
    })
end

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = config,
    keys = {
        -- Projects
        keymap.set("n", "<leader>fd", ":Telescope neovim-project discover<CR>"),

        keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>"),
        keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>"),
        keymap.set("n", "<leader>ff", ":Telescope find_files<CR>"),
        keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>"),
        keymap.set("n", "<leader>fb", ":Telescope buffers<CR>"),
    }
}
