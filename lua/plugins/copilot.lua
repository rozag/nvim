local M = {}

M.ids = {
  copilot = "zbirenbaum/copilot.lua",
  chat = "CopilotC-Nvim/CopilotChat.nvim",
}

M.require_module = {
  copilot = function()
    return require("copilot")
  end,
  chat = function()
    return require("CopilotChat")
  end,
}

M.cmd = {
  main = "Copilot",
  enable = "Copilot enable",
  disable = "Copilot disable",
  status = "Copilot status",

  chatOpen = "CopilotChatOpen",
  chatClose = "CopilotChatClose",
  chatReset = "CopilotChatReset",
  chatExplain = "CopilotChatExplain",
  chatReview = "CopilotChatReview",
  chatFix = "CopilotChatFix",
  chatOptimize = "CopilotChatOptimize",
  chatDocs = "CopilotChatDocs",
  chatTests = "CopilotChatTests",
}

M.chatOpenFloat = function()
  M.require_module.chat().open {
    window = {
      layout = "float",
    },
  }
end
M.chatOpenVsplit = function()
  M.require_module.chat().open {
    window = {
      layout = "vertical",
    },
  }
end
M.chatOpenSplit = function()
  M.require_module.chat().open {
    window = {
      layout = "horizontal",
    },
  }
end
M.chatOpenReplace = function()
  M.require_module.chat().open {
    window = {
      layout = "replace",
    },
  }
end

M.lazy_defs = {
  -- [[ Github Copilot ]]
  -- https://github.com/zbirenbaum/copilot.lua
  {
    M.ids.copilot,
    config = function()
      local kbd = require("kbd")

      M.require_module.copilot().setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = kbd.plugins.copilot.mappings,
        },
        filetypes = {
          yaml = true,
          markdown = true,
        },
      }

      kbd.plugins.copilot.core()
    end,
  },

  -- [[ Github Copilot Chat ]]
  -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
  {
    M.ids.chat,
    branch = "main",
    dependencies = {
      M.ids.copilot,
      { require("plugins.stdlib").ids.plenary, branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      M.require_module.chat().setup {
        -- debug = true,
        model = "gpt-4o",
        window = {
          layout = "float",
          width = 0.5,
          height = 0.5,
          border = "none",
        },
      }
      local kbd = require("kbd")
      kbd.plugins.copilot.chat()
    end,
  },
}

return M
