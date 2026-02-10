# fzf
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
autoload -Uz fzf-cd-widget
zle -N fzf-cd-widget
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
bindkey "ç" fzf-cd-widget

# Pipenv
export PIPENV_VENV_IN_PROJECT=1

# Pyenv - carregamento seguro
export PYENV_ROOT="$HOME/.pyenv"

# Adiciona o bin primeiro
if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Só tenta inicializar se o comando pyenv já existir no PATH atual
if command -v pyenv >/dev/null 2>&1; then
    # Primeiro adiciona os shims ao PATH (muito importante!)
    # eval "$(pyenv init --path)"

    # Depois inicializa o pyenv normal
    eval "$(pyenv init -)"

    # Se você usa virtualenv/virtualenvwrapper, adicione aqui:
    # eval "$(pyenv virtualenv-init -)"
fi

# Poetry
export PATH="$HOME/.local/bin:$PATH"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export STARSHIP_THEME=nord
eval "$(starship init zsh)"
starship config palette $STARSHIP_THEME

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)
autoload -Uz compinit && compinit

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - search in your command history
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# zoxide
eval "$(zoxide init zsh)"

# Activate syntax highlighting and autosuggestions
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Vi mode
bindkey -v
export KEYTIMEOUT=1
export VI_MODE_SET_CURSOR=true

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[2 q'
  else
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  echo -ne '\e[6 q'
}
zle -N zle-line-init
echo -ne '\e[6 q'

# Yank to clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
