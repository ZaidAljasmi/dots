#!/bin/sh
# wmenu-desktop: dmenu-style launcher for .desktop files, respecting
# XDG priority (~/.local/share/applications overrides /usr/share/applications)
# and handling terminal apps (Terminal=true).

TERMINAL="${TERMINAL:-foot}"

DIRS="$HOME/.local/share/applications /usr/local/share/applications /usr/share/applications"

# tmp files: name->exec map, and name->terminal-flag map
MAP=$(mktemp)
trap 'rm -f "$MAP"' EXIT

# Build list, local dirs first so they win on duplicate names.
for dir in $DIRS; do
	[ -d "$dir" ] || continue
	for f in "$dir"/*.desktop; do
		[ -f "$f" ] || continue

		# Skip entries marked NoDisplay=true
		grep -q '^NoDisplay=true' "$f" && continue

		name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
		exec_raw=$(grep -m1 '^Exec=' "$f" | cut -d= -f2-)
		term=$(grep -m1 '^Terminal=true' "$f")

		[ -z "$name" ] && continue
		[ -z "$exec_raw" ] && continue

		# strip desktop field codes (%f %F %u %U %i %c %k etc.)
		exec_clean=$(echo "$exec_raw" | sed 's/%[fFuUick]//g')

		# skip if name already seen (first match = highest priority dir)
		grep -q "^${name}	" "$MAP" 2>/dev/null && continue

		if [ -n "$term" ]; then
			printf '%s\t%s\t1\n' "$name" "$exec_clean" >> "$MAP"
		else
			printf '%s\t%s\t0\n' "$name" "$exec_clean" >> "$MAP"
		fi
	done
done

choice=$(cut -f1 "$MAP" | sort -u | wmenu "$@")
[ -z "$choice" ] && exit 0

line=$(grep -m1 "^${choice}	" "$MAP")
cmd=$(echo "$line" | cut -f2)
isterm=$(echo "$line" | cut -f3)

if [ "$isterm" = "1" ]; then
	exec "$TERMINAL" -e sh -c "$cmd"
else
	exec sh -c "$cmd"
fi
