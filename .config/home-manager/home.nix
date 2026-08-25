{ config, lib, pkgs, ... }:

{
  # GENERAL CONFIGURATION
  home.username = "dominickcs";
  home.homeDirectory = "/home/dominickcs/";

  home.stateVersion = "26.05"; # CHECK RELEASE NOTES BEFORE CHANGING!

  # ENABLE FONT CONFIGURATION
  fonts.fontconfig.enable = true;

  # PACKAGE CONFIGURATION
  home.packages = with pkgs; [
    julia-mono
    neovim
    firefox
    kitty
    slack
    git
    zsh
    tmux
    lazygit
    gcc
    luaPackages.tree-sitter-cli
    curl
    fzf
    ripgrep
    fd
    cargo
    rustc
    rust-analyzer
    rustfmt
    zathura
    wl-clipboard
    markdown-oxide
    lua-language-server
    nodejs

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dominickcs/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # ALLOW UNFREE NIXPKGS
  nixpkgs.config.allowUnfree = true;

  # SWAY CONFIGURATION
  wayland.windowManager.sway = {
  enable = true;
  checkConfig = false;
  wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
  config = rec {
    bars = [
    {
    position = "top";
    statusCommand = "${pkgs.i3status}/bin/i3status";

    fonts = {
      names = [ "JuliaMono" ];
      size = 10.0;
    };

    colors = {
      background = "#363d4bB3";
      statusline = "#ffffff";
      separator = "#666666";

      focusedWorkspace = {
        border = "#994e55";
        background = "#994e55B3";
        text = "#ffffff";
      };

      activeWorkspace = {
        border = "#994e55";
        background = "#994e55B3";
        text = "#ffffff";
      };

      inactiveWorkspace = {
        border = "#363d4b";
        background = "#363d4b";
        text = "#ffffff";
      };

      urgentWorkspace = {
        border = "#994e55";
        background = "#994e55";
        text = "#ffffff";
          };
        };
      }
    ];
    modifier = "Mod4";
    terminal = "kitty -e tmux new-session -A -s main";
    defaultWorkspace = "workspace number 1";
    window = {
        titlebar = false; border = 8; };
    fonts = {
        names = [
          "Julia Mono"
        ];
        size = 12.0;
      };
    gaps = {
        outer = 16;
        inner = 4;
      };
    output = {
        eDP-1 = {
            pos = "0 -1080";
            bg = "~/.wallpapers/wallpaper.png fill";
          };
        DP-6 = {
            mode = "2560x1440@144Hz";
            pos = "-2560 1080";
            bg = "~/.wallpapers/wallpaper.png fill";
          };
        DP-7 = {
            mode = "2560x1440@144Hz";
            pos = "0 1080";
            bg = "~/.wallpapers/wallpaper.png fill";
          };
      };
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "eDP-1"; # BUILT-IN DISPLAY
      }
      {
        workspace = "2";
        output = "DP-6";  # CLOUDKEY DESK
      }
      {
        workspace = "3";
        output = "DP-7";  # CLOUDKEY DESK
      }
    ];
    keybindings = 
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+q" = "exec ${terminal}";
          "${modifier}+Shift+q" = "exec firefox";
          "${modifier}+c" = "kill";
      };
    };
  };

  # i3STATUS CONFIGURATION
  programs.i3status = {
  enable = true;

  general = {
    colors = false;
    interval = 5;
  };

  modules = {
    "wireless _first_" = {
      position = 1;
      settings = {
        format_up = "W: (%quality at %essid) %ip";
        format_down = "W: down";
      };
    };
    "battery all" = {
      position = 2;
      settings = {
        format = "%status %percentage %remaining";
      };
    };
    "disk /" = {
      position = 3;
      settings = { format = "%free"; };
    };
    "load" = {
      position = 4;
      settings = { format = "%1min"; };
    };
    "memory" = {
      position = 5;
      settings = {
        format = "%used / %total";
        threshold_degraded = "10%";
      };
    };
    "tztime local" = {
      position = 6;
      settings = { format = "%Y-%m-%d %H:%M:%S"; };
    };
  };
};

  # XDG DESKTOP PORTAL CONFIGURATION
  xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
  config = {
    common = {
      default = [ "gtk" ];
      };
    };
  };

  # ENABLE ZSH & OH-MY-ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "agnoster";
    };
  };

  # ZATHURA CONFIGURATION
  programs.zathura = {
      enable = true;
  };

  # TMUX CONFIGURATION
  programs.tmux = {
    enable = true;

    # Creates ~/.config/tmux/tmux.conf
    extraConfig = ''
      # ============================================
      # ESSENTIAL SETTINGS
      # ============================================

      set -sg escape-time 0
      set -g history-limit 50000
      set -g mouse on

      set -g base-index 1
      setw -g pane-base-index 1

      set -g focus-events on

      set -g default-terminal "tmux-256color"
      set -as terminal-features ",xterm-256color:RGB"

      setw -g aggressive-resize on

      # ============================================
      # KEY BINDINGS
      # ============================================

      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # ============================================
      # APPEARANCE
      # ============================================

      set -g status-position top

      set -g status-style 'bg=#13161d fg=#8b949e'
      set -g status-left-length 20
      set -g status-right-length 50

      set -g status-left '#[fg=#00e68a,bold] #S #[fg=#30363d]│ '
      set -g status-right '#[fg=#30363d]│#[fg=#8b949e] %H:%M #[fg=#30363d]│#[fg=#8b949e] %d-%b-%y '

      setw -g window-status-format ' #I:#W '
      setw -g window-status-current-format '#[fg=#00e68a,bold] #I:#W '

      set -g pane-border-style 'fg=#30363d'
      set -g pane-active-border-style 'fg=#00e68a'

      set -g message-style 'bg=#00e68a fg=#000000 bold'

      # ============================================
      # COPY MODE
      # ============================================

      setw -g mode-keys vi
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
    '';
  };
  

  # KITTY CONFIGURATION
  programs.kitty = {
  enable = true;

  font = {
    name = "JuliaMono";
    size = 12.0;
  };

  settings = {
    bold_font = "auto";
    italic_font = "auto";
    bold_italic_font = "auto";

    cursor_shape = "block";
    cursor_shape_unfocused = "hollow";
    cursor_blink_interval = "1";
    cursor_stop_blinking_after = "0";
    cursor_trail = "5";
    cursor_trail_decay = "0.1 0.4";
  };

  themeFile = "Ayaka";
};

  # FORCE OVERWRITE KITTY CONFIGURATION
  xdg.configFile."kitty/kitty.conf".force = true;
}
