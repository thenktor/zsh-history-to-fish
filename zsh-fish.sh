#!/bin/zsh
# shellcheck disable=SC3043

ZSH_HISTORY_FILE="$HOME/.zhistory"
FISH_HISTORY_FILE="$HOME/.local/share/fish/fish_history"
BRBLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
Z=$(tput sgr0)

ZSH_HISTORY_READER="zsh -i -c 'fc -R {}; fc -l -t \"%s\" 0'"

fnUsage() {
	echo "Usage: $1 [-d] [-i <input_file>] [-o <output_file>]" 1>&2;
	echo "  -d              : dry-run (don't write output file)" 1>&2;
	echo "  -i <input_file> : path to ZSH history file, default: ~/.zhistory" 1>&2;
	echo "  -o <output_file>: path to Fish history file, default: ~/.local/share/fish/fish_history" 1>&2;
	exit 1;
}

fnReadHistory() {
	local input_file="$1"
	local command
	command=$(eval "${ZSH_HISTORY_READER//\{\}/$input_file}")
	echo "$command" | sed 's/\\n/\n/g'
}

fnParseHistory() {
	fnReadHistory "$1" | awk '{ $1=""; sub(/^ /, ""); print }'
}

fnExporter() {
	local input_file="${1:-$ZSH_HISTORY_FILE}"
	local output_file="${2:-$FISH_HISTORY_FILE}"
	local i=0

	while IFS= read -r line; do
		local timestamp="${line%% *}"
		local command_zsh="${line#* }"
		local fish_history="- cmd: $command_zsh\n  when: $timestamp\n"

		echo "$fish_history" >> "$output_file"

		i=$((i + 1))
		[ $((i % 1000)) -eq 0 ] && printf "."
	done < <(fnParseHistory "$input_file")
	
	printf "\nProcessed %s%s%s commands.\n" "${BLUE}" "${i}" "${Z}"
}

while getopts "dhi:o:" OPT; do
	case $OPT in
		d) DRY_RUN="1" ;;
		i) ZSH_HISTORY_FILE="$OPTARG" ;;
		o) FISH_HISTORY_FILE="$OPTARG" ;;
		*) fnUsage "$0" ;;
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
BLUE=$(tput setaf 4)
printf "%s\n" "${BRBLUE}input ${Z}: ${BLUE}${ZSH_HISTORY_FILE}${Z}"
printf "%s" "${BRBLUE}output${Z}: ${BLUE}${FISH_HISTORY_FILE}${Z}"
if [ "$DRY_RUN" = "1" ]; then
	printf " %sdry run!%s\n" "${YELLOW}" "${Z}"
else
	printf "\n"
fi

fnExporter "$ZSH_HISTORY_FILE $FISH_HISTORY_FILE"
