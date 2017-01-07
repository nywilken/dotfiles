# Only set this if we haven't set $EDITOR up somewhere else previously.
if [[ "$EDITOR" == "" ]] ; then
  # Use sublime for my editor.
  export EDITOR='subl'
fi

if [[ "$GOPATH" == "" ]] ; then
  export GOPATH=$HOME/Development/golang
fi
