export RBENV_ROOT="/opt/rbenv/rbenv-<%= @rbenv_version %>"
export PATH="${RBENV_ROOT}/bin:$PATH"
eval "$(rbenv init -)"
