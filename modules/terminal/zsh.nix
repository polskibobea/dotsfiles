{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
    ];
    shellAliases = {
      ls = "eza --icons --color=always --group-directories-first";
    };
  };
}
