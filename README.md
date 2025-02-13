# Convert your ZSH history to Fish shell

This is a simple shell script to ease the migration from ZSH to Fish shell. It converts the ZSH history to Fish.

This is a shell rewrite of [rsalmei/zsh-history-to-fish](https://github.com/rsalmei/zsh-history-to-fish), because I did not want to install Python for this small task.

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
  -i <input_file> : path to ZSH history file, default: ~/.zhistory
  -o <output_file>: path to Fish history file, default: ~/.local/share/fish/fish_history
```
