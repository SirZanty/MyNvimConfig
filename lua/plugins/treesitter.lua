-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Comando para instalar/actualizar parsers
  -- Usamos `opts` para pasar la configuración y `main` para especificar el punto de entrada.
  -- Esto es más robusto y es la forma recomendada por lazy.nvim.
  main = "nvim-treesitter.config",
  opts = {
    -- Lista de parsers a instalar. Añade más lenguajes aquí.
    ensure_installed = {
      "c_sharp",
      "lua",
      "c", -- Base para muchos otros parsers
      "json",
      "bash",
    },

    -- Instalar parsers de forma síncrona (bloquea Neovim hasta que termine)
    -- Es mejor en `false` para que se instalen en segundo plano.
    sync_install = false,

    -- Instalar automáticamente parsers para lenguajes no presentes
    auto_install = true,

    -- Activar el módulo de resaltado de sintaxis
    highlight = {
      enable = true,
    },

    -- Activar el módulo de indentación basada en Tree-sitter
    indent = {
      enable = true,
    },

    -- Activar el módulo de plegado de código
    folding = {
      enable = true,
    },
  },
}
