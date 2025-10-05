return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dR",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("[Expression] > "))
        end,
        desc = "Evaluate Input",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Evaluate",
      },
      {
        "<leader>dC",
        function()
          require("dap").set_breakpoint(
            vim.fn.input("[Condition] > ")
          )
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dL",
        function()
          require("dap").set_breakpoint(
            nil,
            nil,
            vim.fn.input("Log point message: ")
          )
        end,
        silent = true,
        desc = "Set Breakpoint",
      },
      {
        "<leader>dU",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause.toggle()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").step_back()
        end,
        desc = "Step Back",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>ds",
        function()
          require("dap").continue()
        end,
        desc = "Start",
      },
      {
        "<leader>dd",
        function()
          require("dap").disconnect()
        end,
        desc = "Disconnect",
      },
      {
        "<leader>dg",
        function()
          require("dap").session()
        end,
        desc = "Get Session",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover Variables",
      },
      {
        "<leader>dS",
        function()
          require("dap.ui.widgets").scopes()
        end,
        desc = "Scopes",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dq",
        function()
          require("dap").close()
        end,
        desc = "Quit",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dO",
        function()
          require("dap").repl.open()
        end,
        silent = true,
        desc = "Repl Open",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        silent = true,
        desc = "Run Last",
      },
    },
    config = function()
      local dap = require("dap")

      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb",
        name = "lldb",
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input(
              "Path to executable: ",
              vim.fn.getcwd() .. "/",
              "file"
            )
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          -- If you get an "Operation not permitted" error using this, try disabling YAMA:
          --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
          name = "Attach to process",
          type = "cpp", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp

      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host,
          port = config.port,
        })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = function()
            local value = vim.fn.input("Host [127.0.0.1]: ")
            if value ~= "" then
              return value
            end
            return "127.0.0.1"
          end,
          port = function()
            local val = tonumber(vim.fn.input("Port: ", "8086"))
            assert(val, "Please provide a port number")
            return val
          end,
        },
      }
    end,
  },
}
