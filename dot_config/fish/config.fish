set -g PATH /opt/homebrew/bin /usr/local/bin /usr/sbin /usr/bin $PATH
set -g theme_display_git_master_branch yes
# ruby version
set -g theme_display_ruby yes
set -g theme_display_user yes

# ssh-agent
# https://gist.github.com/gerbsen/5fd8aa0fde87ac7a2cae
# content has to be in .config/fish/config.fish
# if it does not exist, create the file
setenv SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add -K ~/.ssh/github_rsa
    # ssh-add -K ~/.ssh/id_rsa_mhack_default
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add -K ~/.ssh/github_rsa
        # ssh-add -K ~/.ssh/id_rsa_mhack_default
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end

# anyenv path
set -x PATH $HOME/.anyenv/bin $PATH
#eval (anyenv init - | source)
#bashで実行しようとするため文法エラーになる

#anyenv rbenv
set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
set -x PATH $PATH "$RBENV_ROOT/bin"
set -gx PATH '/Users/kindaichi/.anyenv/envs/rbenv/shims' $PATH
set -gx RBENV_SHELL fish
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    rbenv "sh-$command" $argv|source
  case '*'
    command rbenv "$command" $argv
  end
end
#see https://patorash.hatenablog.com/entry/2017/09/15/154649
#source '/Users/kindaichi/.anyenv/envs/rbenv/libexec/../completions/rbenv.fish'

# aws-cli
# set PATH $HOME/.local/bin $PATH

# for openssl@1.1
set PATH /opt/homebrew/opt/openssl@1.1/bin $PATH

# for mysql
set PATH /opt/homebrew/opt/mysql@5.7/bin $PATH
# set -gx PATH '/usr/local/opt/mysql@5.7/bin' $PATH

# for mysql-client
set PATH /opt/homebrew/opt/mysql-client@5.7/bin $PATH

# for imagemagick@6
set PATH /opt/homebrew/opt/imagemagick@6/bin $PATH

# ctrl+r でhistoryでfzfを有効にする
function fish_user_key_bindings
    bind \cr "history | fzf" # Bind for history to Ctrl+r
end

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -gx FZF_DEFAULT_OPTS "--height 70% --border --color=light"
set -gx FZF_ALT_C_OPTS "--select-1 --exit-0"
## sshコマンドでfzfを有効にする
## https://github.com/junegunn/fzf/wiki/Examples-(fish)#ssh
function fssh -d "Fuzzy-find ssh host via ag and ssh into it"
    rg --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end
## tmux
# function fs -d "Switch tmux session"
#   tmux list-sessions -F "#{session_name}" | fzf | read -l result; and tmux switch-client -t "$result"
# end

# .node_modules/.bin
set PATH './node_modules/.bin' $PATH

# gpg
set -gx GPG_TTY (tty)

# bundler
set -gx BUNDLER_EDITOR /opt/homebrew/bin/code

# homebrew
set -gx HOMEBREW_EDITOR /opt/homebrew/bin/code

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# tabechoku
set -gx AWS_PROFILE tabechoku-sso

# Go
set -gx GOPATH $HOME/go
set -gx PATH "$GOPATH/bin" $PATH

# fzf with fd
set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"

# zoxide
zoxide init fish | source
# 必要ならばセットする
# set -gx _ZO_DATA_DIR /path/to/

# starship
starship init fish | source
