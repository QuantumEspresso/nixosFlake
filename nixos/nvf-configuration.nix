{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        lsp.enable = true;
        #theme = {
        # enable = true;
        # name = "gruvbox";
        # style = "dark";
        #};
        languages = {
          # general settings for all enabled languages
          enableDAP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # languages to recongnize
          bash.enable = true;
          clang.enable = true;
          # css.enable = true;
          lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          python.enable = true;
          rust.enable = true;
          # ts.enable = true;
        };
        options = {
          tabstop = 2;
          shiftwidth = 2;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        # autocomplete.nvim-cmp = {
        #  enable = true;
        #  sourcePlugins = [
        #  ];
        # };
        mini = {
          # text editing
          ai.enable = true;
          align.enable = true;
          comment.enable = true;
          completion.enable = true;
          move.enable = true;
          operators.enable = true;
          pairs.enable = true;
          snippets.enable = true;
          splitjoin.enable = true;
          surround.enable = true;
          # general workflow
          clue.enable = true;
          diff.enable = true;
          files.enable = true;
          git.enable = true;
          jump.enable = true;
          jump2d.enable = true;
          sessions.enable = true;
          fuzzy.enable = true;
        };
        maps = {
          visual = {
            # swap paste commands
            p.action = "P";
            P.action = "p";
          };
          command = {
            # aliases for saving
            # W.action = "w";
            # Q.action = "q";
            # A.action = "a";
          };
        };
        dashboard = {
          startify = {
            enable = true;
            #sessionAutoload = true;
            sessionDir = "~/.vim/session";
          };
        };
        lazy.plugins = {
          # plugin list
        };
        filetree.nvimTree.enable = true;
        visuals.nvim-web-devicons.enable = true;
        tabline.nvimBufferline.enable = true;
      };
    };
  };
}
