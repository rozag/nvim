local M = {}

M.ids = {
  mason = "williamboman/mason.nvim",
  mason_lspconfig = "williamboman/mason-lspconfig.nvim",
}

M.require_module = {
  mason = function()
    return require("mason")
  end,
  mason_lspconfig = function()
    return require("mason-lspconfig")
  end,
}

M.filetypes = {
  "mason",
}

M.cmd = "Mason"

M.lazy_defs = {
  -- [[ Sort of a package manager ]]
  -- https://github.com/williamboman/mason.nvim
  -- Package list: https://mason-registry.dev/registry/list
  {
    M.ids.mason,
    build = ":MasonUpdate",
    cmd = {
      M.cmd,
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    config = function()
      M.require_module.mason().setup {
        PATH = "skip",
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌",
          },
        },
        max_concurrent_installers = 10,
      }
    end,
  },

  -- [[ Stuff for Mason ]]
  -- https://github.com/williamboman/mason-lspconfig.nvim
  -- Package list: https://mason-registry.dev/registry/list
  {
    M.ids.mason_lspconfig,
    config = function()
      local ensure_installed =
          require("plugins.langs").mason_lspconfig_ensure_installed
      M.require_module.mason_lspconfig().setup {
        ensure_installed = ensure_installed,
      }

      require("kbd").plugins.mason()
    end,
  },
}

return M
