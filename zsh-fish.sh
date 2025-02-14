#!/usr/bin/env zsh

ZSH_HISTORY_FILE=$(zsh -ic 'echo $HISTFILE')
if [ -z "$ZSH_HISTORY_FILE" ]; then ZSH_HISTORY_FILE="$HOME/.zhistory"; fi
FISH_HISTORY_FILE="$HOME/.local/share/fish/fish_history"

if which tput > /dev/null; then
	BRBLUE=$(tput setaf 153)
	BLUE=$(tput setaf 4)
	YELLOW=$(tput setaf 3)
	NOCOLOR=$(tput sgr0)
else
	BRBLUE=""
	BLUE=""
	YELLOW=""
	NOCOLOR=""
fi

fnUsage() {
	echo "Usage: $1 [-d] [-i <input_file>] [-o <output_file>]" 1>&2;
	echo "  -d              : dry-run (don't write output file)" 1>&2;
	echo "  -i <input_file> : path to ZSH history file, default: \$HISTFILE or ~/.zhistory" 1>&2;
	echo "  -o <output_file>: path to Fish history file, default: ~/.local/share/fish/fish_history" 1>&2;
}

fnParseHistory() {
	local INPUT_FILE="$1"
	zsh -i -c 'fc -R '"$INPUT_FILE"'; fc -l -t \"%s\" 0' | awk '{ $1=""; sub(/^ /, ""); print }'
}

while getopts "dhi:o:" OPT; do
	case $OPT in
		d) DRY_RUN="1" ;;
		i) ZSH_HISTORY_FILE="$OPTARG" ;;
		o) FISH_HISTORY_FILE="$OPTARG" ;;
		h) fnUsage "$0"; exit 0 ;;
		*) fnUsage "$0"; exit 1 ;;
	esac
done

if [ "$DRY_RUN" = "1" ]; then
	FISH_HISTORY_FILE="/dev/null"
fi
if [ ! -e "$ZSH_HISTORY_FILE" ]; then
	echo "ERROR: $ZSH_HISTORY_FILE does not exist."
	exit 1
fi

echo "ZSH history to Fish"
echo "==================="
echo -e "${BRBLUE}input ${NOCOLOR}: ${BLUE}${ZSH_HISTORY_FILE}${NOCOLOR}"
echo -e -n "${BRBLUE}output${NOCOLOR}: ${BLUE}${FISH_HISTORY_FILE}${NOCOLOR}"
if [ "$DRY_RUN" = "1" ]; then
	echo -e "${YELLOW}dry run!${NOCOLOR}"
else
	echo ""
fi

i=0
while IFS= read -r line; do
	TIMESTAMP="${line%% *}"
	COMMAND_ZSH="${line#* }"

	if [ -z "$COMMAND_ZSH" ]; then continue; fi

	echo -E "- cmd: $COMMAND_ZSH" >> "$FISH_HISTORY_FILE"
	echo "  when: $TIMESTAMP" >> "$FISH_HISTORY_FILE"

	i=$((i + 1))
	[ $((i % 1000)) -eq 0 ] && printf "."
done < <(fnParseHistory "$ZSH_HISTORY_FILE")

echo -e "\nProcessed ${BLUE}${i}${NOCOLOR} commands."
