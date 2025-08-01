return {
    'mfussenegger/nvim-dap',
    config = function()
        local languages = { "javascript", "typescript" }
        local dap = require('dap')
        for _, lang in ipairs(languages) do
            dap.configurations[lang] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch TS file",
                    runtimeExecutable = "ts-node",
                    program = "${file}",
                    sourceMaps = true,
                    protocol = "inspector",
                    cwd = "${workspaceFolder}",
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = "Launch TS Deno",
                    runtimeExecutable = "deno",
                    runtimeArgs = {
                        "run",
                        "--inspect-wait",
                        "--allow-all"
                    },
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require 'dap.utils'.pick_process,
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Start Chrome with \"localhost\"",
                    url = "http://localhost:3000",
                    webRoot = "${workspaceFolder}",
                    userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
                }
            }
        end
    end,
    dependencies = {
        {
            'rcarriga/nvim-dap-ui',
            opts = {},
            config = function(_, opts)
                require("dapui").setup()

                local dap, dapui = require("dap"), require("dapui")

                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end

        },
        {
            "microsoft/vscode-js-debug",
            -- After install, build it and rename the dist directory to out
            build =
            "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
            version = "1.*",
        },
        {
            "mxsdev/nvim-dap-vscode-js",
            config = function()
                ---@diagnostic disable-next-line: missing-fields
                require("dap-vscode-js").setup({
                    -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                    -- node_path = "node",

                    -- Path to vscode-js-debug installation.
                    debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

                    -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
                    -- debugger_cmd = { "js-debug-adapter" },

                    -- which adapters to register in nvim-dap
                    adapters = {
                        "chrome",
                        "pwa-node",
                        "pwa-chrome",
                        "pwa-msedge",
                        "pwa-extensionHost",
                        "node-terminal",
                    },

                    -- Path for file logging
                    -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

                    -- Logging level for output to file. Set to false to disable logging.
                    -- log_file_level = false,

                    -- Logging level for output to console. Set to false to disable console output.
                    -- log_console_level = vim.log.levels.ERROR,
                })
            end,
        },
        {
            "Joakker/lua-json5",
            build = "./install.sh",
        },
    },

}
