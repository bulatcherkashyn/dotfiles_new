return {
  "mfussenegger/nvim-dap",
  config = function()
    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = 8123,
      executable = {
        --command = "js-debug-adapter"
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        --args = { "/home/busyok/custom_progs/vscode-js-debug/src/dapDebugServer.js", "${port}" },
        args = { "/home/busyok/custom_progs/js-debug/src/dapDebugServer.js", 8123 },
      }
    }

    for _, language in ipairs { "typescript", "javascript" } do
      require("dap").configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node"
        },
      }
    end
  end
}
