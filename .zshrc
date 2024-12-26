export GOPRIVATE=github.com/x-asia/api-go/*
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:~/cargo/bin
export PATH=$PATH:/Users/apple/.local/share/solana/install/active_release/bin
export NODEBREW_ROOT=/opt/homebrew/var/nodebrew
export PATH=$PATH:/Users/apple/.nodebrew/current/bin
export PATH=$PATH:/opt/homebrew/var/nodebrew/current/bin
export PATH=$PATH:/usr/bin/gcc
export PATH=$PATH:/opt/homebrew/Cellar
export PATH=$PATH:/Users/apple/go/bin
setopt +o nomatch
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export GOPATH=/Users/apple/go
# export PATH="/Users/shota.kono.001/Library/Python/3.9/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

export AWS_DEFAULT_PROFILE=refundhub
alias g=git
alias co=code
alias m=make
alias y=yarn
alias n=nvim
alias ni='nvim ~/.config/nvim/init.lua'
cn() {
  cd "$1" && nvim "$1"
}




### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/apple/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# https://medium.com/@vkmauryavk/resolving-sslcertverificationerror-certificate-verify-failed-unable-to-get-local-issuer-515d7317454f
export EQUESTS_CA_BUNDLE=/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages/certifi/cacert.pem

export PATH="$HOME/bin:$PATH"

# docker
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# starship
eval "$(starship init zsh)"

