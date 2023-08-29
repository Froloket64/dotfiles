local dap = require("dap")

dap.adapters.rust = {
    type = "executable";
    command = "lldb_vscode";
    -- command = "/usr/bin/lldb_vscode";
    -- args = {};
}

dap.configurations.rust = {
    {
        type = "rust";
        request = "launch";
        name = "Run deez nuts";
    }
}
