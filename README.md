# Convert your ZSH history to Fish shell

This is a simple shell script to ease the migration from [ZSH](https://www.zsh.org/) to [Fish shell](https://fishshell.com/). It converts the ZSH history to Fish.

This is a shell rewrite of [rsalmei/zsh-history-to-fish](https://github.com/rsalmei/zsh-history-to-fish).

# Dependencies

Just `zsh`, `sed` and `awk`.

# Installation

If you have `git` available, you can clone the repository:

```txt
git clone https://github.com/thenktor/zsh-history-to-fish.git
```

Without `git` you can just download the file:

```txt
curl -L https://raw.githubusercontent.com/thenktor/zsh-history-to-fish/refs/heads/main/zsh-fish.sh -o zsh-fish.sh
chmod +x zsh-fish.sh
```

# Usage

```txt
# ./zsh-fish.sh -h
Usage: ./zsh-fish.sh [-d] [-i <input_file>] [-o <output_file>]
  -d              : dry-run (don't write output file)
  -i <input_file> : path to ZSH history file, default: $HISTFILE or ~/.zhistory
  -o <output_file>: path to Fish history file, default: ~/.local/share/fish/fish_history
```

Note: Usual file names for the ZSH history file are `~/.zhistory` or `~/.zsh_history`.
