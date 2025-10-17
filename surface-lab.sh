#!/usr/bin/env bash
set -Eeuo pipefail

MISSION_FILE="$HOME/scripts/missions.txt"

header(){ printf "\n------------------------------\n SURFACE LAB LAUNCHPAD\n------------------------------\n"; }

update_system(){ echo "Updating system packages..."; if command -v sudo >/dev/null 2>&1; then sudo apt update && sudo apt upgrade -y; else apt update && apt upgrade -y; fi; echo "All packages up to date"; }

sysinfo(){
  echo "\nSystem Info:"
  if command -v neofetch >/dev/null 2>&1; then neofetch
  else
    host="$(hostname)"
    up="$(uptime -p 2>/dev/null || true)"
    kern="$(uname -r)"
    mem="$(free -h | awk '/Mem:/ {print $3\"/\"$2\" used\"}')"
    ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
    printf "Host: %s\nUptime: %s\nKernel: %s\nMemory: %s\nIP: %s\n" "$host" "${up:-n/a}" "$kern" "$mem" "${ip:-n/a}"
  fi
}

ensure_missions(){ [ -f "$MISSION_FILE" ] || cat > "$MISSION_FILE" << 'EOM'
Practice file permissions with chmod.
Run: nmap -A localhost and identify open ports.
Write a Bash script that prints your IP addresses.
Learn 3 new apt commands (search, show, purge).
Create ~/scripts and add a script with #!/usr/bin/env bash.
Use tmux: create a session and split panes.
Practice grep, awk, and sed on a sample log file.
Scan your LAN with: sudo nmap -sn 192.168.1.0/24 (adjust subnet).
Hardening: enable and check ufw; allow OpenSSH only.
Write a Zsh alias for ll and cls.
EOM
}

next_mission(){ ensure_missions; pick="$(shuf -n1 "$MISSION_FILE" 2>/dev/null || head -n1 "$MISSION_FILE")"; printf "\nToday's Mission:\n\"%s\"\n" "$pick"; }

learn_tip(){
  tips=(
    "Use lsblk to list drives."
    "Use sudo journalctl -xe to read logs."
    "Use history | grep <word> to recall commands."
    "Run htop or btop to monitor processes."
    "Use sudo ufw status to check firewall."
    "Ping test: ping -c 4 google.com"
    "Search configs: grep -R keyword /etc"
    "Make scripts executable: chmod +x file.sh"
    "View network interfaces: ip a"
  )
  echo "Tip: ${tips[$((RANDOM % ${#tips[@]}))]}"
}

launch_tools(){ command -v btop >/dev/null 2>&1 && echo "Launching btop (press q to exit)..." && sleep 1 && btop; }

add_mission(){ ensure_missions; [ "${1:-}" ] || { echo 'Usage: lab add "your mission text"'; exit 1; }; printf "%s\n" "$*" >> "$MISSION_FILE" && echo "Added mission: $*"; }
list_missions(){ ensure_missions; nl -w2 -s". " "$MISSION_FILE"; }
edit_missions(){ ensure_missions; "${EDITOR:-nano}" "$MISSION_FILE"; }

case "${1:-run}" in
  run|default) header; update_system; sysinfo; next_mission; learn_tip; launch_tools ;;
  update) header; update_system ;;
  info) header; sysinfo ;;
  next) header; next_mission ;;
  add) shift; add_mission "$@" ;;
  list) list_missions ;;
  edit) edit_missions ;;
  *) echo "Usage: lab [run|update|info|next|add <text>|list|edit]" ;;
esac
