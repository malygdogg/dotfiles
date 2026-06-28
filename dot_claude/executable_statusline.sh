#!/bin/bash
input=$(cat)
E=$(printf '\033')

if [ -n "$input" ] && command -v jq >/dev/null 2>&1; then
    cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
    model=$(echo "$input" | jq -r '.model.display_name // ""')
    used=$(echo "$input" | jq -r '
        .context_window.used_percentage // "" |
        if . == "" then "" else (. | round | tostring) end
    ')
    session=$(echo "$input" | jq -r '
        .rate_limits.five_hour as $fh |
        if $fh.used_percentage == null or $fh.resets_at == null then ""
        else
            ($fh.resets_at - now | if . < 0 then 0 else . end | floor) as $secs |
            ($secs / 3600 | floor) as $h |
            ($secs % 3600 / 60 | floor) as $m |
            ($m | tostring | if length == 1 then "0" + . else . end) as $mm |
            (if $h > 0 then "\($h)h\($mm)m" else "\($m)m" end) as $remaining |
            "\($fh.used_percentage | floor)% \($remaining)"
        end
    ')
    session_pct=$(echo "$input" | jq -r '
        .rate_limits.five_hour.used_percentage // "" |
        if . == "" then "" else (. | floor | tostring) end
    ')
    weekly=$(echo "$input" | jq -r '
        if .rate_limits.seven_day.used_percentage == null then ""
        else "\(.rate_limits.seven_day.used_percentage | floor)%"
        end
    ')
else
    cwd="" model="" used="" session="" session_pct="" weekly=""
fi

[ -z "$cwd" ] && cwd="$PWD"
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
cwd=$(echo "$cwd" | sed "s|^$HOME|~|")

# Nerd Font icons
I_FOLDER=$''   # folder-open
I_BRANCH=$''  # git branch
I_MODEL=$'\uf0e7'  # bolt
I_CTX=$''     # bar chart
I_SESSION=$'' # hourglass
I_WEEKLY=$''  # calendar

X="${E}[0m"
GREY="${E}[38;5;244m"
BLUE="${E}[38;5;111m"
GREEN="${E}[38;5;149m"
PURPLE="${E}[38;5;141m"
CYAN="${E}[38;5;117m"
RED="${E}[1;38;5;210m"


# cwd + branch
if [ -n "$branch" ]; then
    printf '%s%s%s %s%s %s%s%s%s' "$GREY" "$I_FOLDER" "$X" "$BLUE" "$cwd" "$GREY$I_BRANCH$X" "$GREEN" "$branch" "$X"
else
    printf '%s%s%s %s%s%s' "$GREY" "$I_FOLDER" "$X" "$BLUE" "$cwd" "$X"
fi

# model + stats
if [ -n "$model" ]; then
    printf ' | %s%s%s %s%s%s' "$GREY" "$I_MODEL" "$X" "$PURPLE" "$model" "$X"

    if [ -n "$used" ]; then
        if [ "$used" -ge 90 ] 2>/dev/null; then
            printf ' %s%s%s %s%s%%%s' "$GREY" "$I_CTX" "$X" "$RED" "$used" "$X"
        else
            printf ' %s%s%s %s%s%%%s' "$GREY" "$I_CTX" "$X" "$CYAN" "$used" "$X"
        fi
    fi

    if [ -n "$session" ]; then
        if [ -n "$session_pct" ] && [ "$session_pct" -ge 90 ] 2>/dev/null; then
            printf ' %s%s%s %s%s%s' "$GREY" "$I_SESSION" "$X" "$RED" "$session" "$X"
        else
            printf ' %s%s%s %s%s%s' "$GREY" "$I_SESSION" "$X" "$CYAN" "$session" "$X"
        fi
    fi

    [ -n "$weekly" ] && printf ' %s%s%s %s%s%s' "$GREY" "$I_WEEKLY" "$X" "$CYAN" "$weekly" "$X"
fi

printf '\n'
