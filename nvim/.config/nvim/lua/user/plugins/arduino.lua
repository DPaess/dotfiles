-- requires arduino-cli installed on the system:
-- https://arduino.github.io/arduino-cli/installation/
-- arduino-language-server is managed by mason
return {
    "yuukiflow/Arduino-Nvim",
    ft = "arduino",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require("Arduino-Nvim").setup({
            board = "arduino:avr:nano",
        })
        require("Arduino-Nvim.lsp").setup_arduino_lsp()
    end,
}
