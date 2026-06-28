{pkgs, ...}:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim.extraPlugins = with pkgs.vimPlugins; {
        nvim-highlight-colors = {
          package = nvim-highlight-colors;
          setup = "require('nvim-highlight-colors').setup({})"; 
        };
      };
      vim.options = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = -1;
        expandtab = true;
      };
      vim.autocomplete.nvim-cmp.enable = true;
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.languages.css = {
        enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
      vim.languages.kotlin ={
        enable = true;
        extraDiagnostics.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
      vim.languages.nix = {
        enable = true;
        extraDiagnostics.types = ["statix" "deadnix"];
        format.enable = true;
        format.type = ["alejandra"];
        treesitter.enable = true;
        lsp = {
          enable = true;
          servers = ["nixd"];
        };
      };
      vim.languages.ts ={
        enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        extraDiagnostics.enable = true;
      };
    };
  };
}
