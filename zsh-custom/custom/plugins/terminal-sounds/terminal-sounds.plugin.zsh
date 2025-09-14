# terminal-sounds.plugin.zsh (no ZLE / Ctrl+L)
# One-file oh-my-zsh plugin: wrappers + control + safe announcement

# ---- Load guard
[[ -n ${_TS_PLUGIN_LOADED} ]] && return
typeset -g _TS_PLUGIN_LOADED=1

# ---- Tame warning: “defining function based on alias”
setopt no_alias_func_def

# ---- Config (override these in .zshrc BEFORE oh-my-zsh.sh)
: ${TERMINAL_SOUNDS_AUTO_ENABLE:=1}      # 1 = auto-enable on load
: ${TERMINAL_SOUNDS_ANNOUNCE:=1}         # 1 = print "enabled" AFTER first prompt
: ${TERMINAL_SOUNDS_DISABLE_ON_SSH:=0}   # 1 = don't auto-enable over SSH

# Sound paths (override with _SND_* in .zshrc if you like)
: ${_SND_INFO:=/usr/share/sounds/freedesktop/stereo/dialog-information.oga}
: ${_SND_LOGIN:=/usr/share/sounds/freedesktop/stereo/service-login.oga}
: ${_SND_LOGOUT:=/usr/share/sounds/freedesktop/stereo/service-logout.oga}
: ${_SND_COMPLETE:=/usr/share/sounds/freedesktop/stereo/complete.oga}
: ${_SND_QUESTION:=/usr/share/sounds/freedesktop/stereo/dialog-question.oga}
: ${_SND_ERROR:=/usr/share/sounds/freedesktop/stereo/dialog-error.oga}
: ${_SND_VOLUME:=/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga}

# ---- Helper: play + disown, fully silent
_sound_play() { ( command paplay "$1" >/dev/null 2>&1 ) &! }

# ---- Control
enable-sound() {
  [[ -n ${_TS_ENABLED} ]] && return
  typeset -g _TS_ENABLED=1

  # Remove conflicting aliases
  unalias l la ll lsa ls cd .. nano code git-init git-commit git-pull git-push git-status clear exit 2>/dev/null

  # ----- Internal wrappers (safe names), sound on START
  _ts_ls()         { _sound_play "$_SND_INFO";     command ls "$@"; }
  _ts_l()          { _sound_play "$_SND_INFO";     command ls -lah --color=auto "$@"; }
  _ts_ll()         { _sound_play "$_SND_INFO";     command ls -lh  --color=auto "$@"; }
  _ts_la()         { _sound_play "$_SND_INFO";     command ls -lAh --color=auto "$@"; }
  _ts_lsa()        { _sound_play "$_SND_INFO";     command ls -lah --color=auto "$@"; }

  _ts_cd()         { _sound_play "$_SND_VOLUME";   builtin cd "$@"; }
  _ts_dotdot()     { _sound_play "$_SND_VOLUME";   builtin cd ..; }

  _ts_nano()       { _sound_play "$_SND_LOGIN";    command nano "$@"; }
  _ts_code()       { _sound_play "$_SND_LOGIN";    command code "$@"; }

  _ts_git_init()   { _sound_play "$_SND_LOGIN";    command git init   "$@"; }
  _ts_git_commit() { _sound_play "$_SND_INFO";     command git commit "$@"; }
  _ts_git_pull()   { _sound_play "$_SND_COMPLETE"; command git pull   "$@"; }
  _ts_git_push()   { _sound_play "$_SND_COMPLETE"; command git push   "$@"; }
  _ts_git_status() { _sound_play "$_SND_QUESTION"; command git status "$@"; }

  _ts_clear()      { _sound_play "$_SND_LOGOUT";   command clear "$@"; }
  _ts_exit()       { _sound_play "$_SND_LOGOUT";   builtin exit; }

  # ----- Public names via aliases
  alias ls=_ts_ls
  alias l=_ts_l
  alias ll=_ts_ll
  alias la=_ts_la
  alias lsa=_ts_lsa

  alias cd=_ts_cd
  alias ..=_ts_dotdot

  alias nano=_ts_nano
  alias code=_ts_code

  alias git-init=_ts_git_init
  alias git-commit=_ts_git_commit
  alias git-pull=_ts_git_pull
  alias git-push=_ts_git_push
  alias git-status=_ts_git_status

  alias clear=_ts_clear
  alias exit=_ts_exit

  # Global error sound (before prompt if last cmd failed)
  autoload -Uz add-zsh-hook
  my_sound_precmd(){ [[ $? -ne 0 ]] && _sound_play "$_SND_ERROR"; }
  add-zsh-hook precmd my_sound_precmd

  # Reattach completion
  (( $+functions[_ls]   )) && compdef _ls   ls l ll la lsa   || compdef _gnu_generic ls l ll la lsa
  (( $+functions[_cd]   )) && compdef _cd   cd ..
  (( $+functions[_nano] )) && compdef _nano nano || compdef _gnu_generic nano
  (( $+functions[_code] )) && compdef _code code || compdef _gnu_generic code
  (( $+functions[_git]  )) && compdef _git  git-init git-commit git-pull git-push git-status

  # Post-prompt one-time announcement (instant-prompt safe)
  if [[ ${TERMINAL_SOUNDS_ANNOUNCE} == 1 ]]; then
    _ts_announce_once(){ print -r -- "🔊 Terminal sound mode ENABLED"; add-zsh-hook -d precmd _ts_announce_once }
    add-zsh-hook precmd _ts_announce_once
  fi
}

disable-sound() {
  [[ -z ${_TS_ENABLED} ]] && return
  unset _TS_ENABLED

  # Remove our aliases
  unalias l la ll lsa ls cd .. nano code git-init git-commit git-pull git-push git-status clear exit 2>/dev/null

  # Remove our hooks
  autoload -Uz add-zsh-hook
  add-zsh-hook -d precmd _ts_announce_once 2>/dev/null
  typeset -f my_sound_precmd >/dev/null && add-zsh-hook -d precmd my_sound_precmd
}

toggle-sound(){ [[ -n ${_TS_ENABLED} ]] && disable-sound || enable-sound }

# ---- Auto-enable (interactive shells only; optional SSH skip)
if [[ -o interactive && ${TERMINAL_SOUNDS_AUTO_ENABLE} == 1 ]]; then
  if [[ ${TERMINAL_SOUNDS_DISABLE_ON_SSH} == 1 && -n ${SSH_CONNECTION} ]]; then
    :  # skip auto-enable on SSH
  else
    enable-sound
  fi
fi
