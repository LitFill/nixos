{ pkgs, ... }:
{
  programs.tmux = {
    enable = false;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      tokyo-night-tmux
      yank
      resurrect
    ];

    extraConfig = /* tmux */ ''
      # Kirim C-a ke aplikasi bersarang dengan menekan C-a dua kali
      bind C-a send-prefix

      # Pindah antar panel dengan tombol panah tanpa prefix
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D

      # Ubah ukuran panel dengan Shift + Panah tanpa prefix
      bind -n S-Left  resize-pane -L 2
      bind -n S-Right resize-pane -R 2
      bind -n S-Up    resize-pane -U 2
      bind -n S-Down  resize-pane -D

      # Split panel dengan | dan -
      bind | split-window -h
      bind - split-window -v

      # Unbind kunci yang tidak intuitif
      unbind '"'
      unbind %

      # Mulai penomoran panel dari 1

      setw -g pane-base-index 1

      # Reload konfigurasi
      bind r source-file ~/.config/tmux/tmux.conf \; display "Konfigurasi di-reload"

      # Membenarkan warna dalam tmux
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g  default-terminal   "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q']]'
    '';
  };
}
