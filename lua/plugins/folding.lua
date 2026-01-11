-- lua/plugins/folding.lua
return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "1" -- Muestra una columna para el plegado
    vim.o.foldlevel = 99 -- Inicia con todos los pliegues abiertos
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Configurar UFO para que use Tree-sitter como proveedor por defecto
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end,
}
