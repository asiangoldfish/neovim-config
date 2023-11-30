local config = function()
    require("nvim-treesitter.configs").setup({
        indent = {
            enable = true
        },
        autotag = {
            enable = true
        },
        ensure_installed = {
            "markdown",
            "json",
            "javascript",
            "yaml",
            "xml",
            "css",
            "html",
            "bash",
            "fish",
            "dockerfile",
            "gitignore",
            "python",
            "c",
            "cpp",
            "java",
            "glsl",
            "hlsl"
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true
        }
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = config
}
