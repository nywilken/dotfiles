#!/bin/sh

WORKON_HOME=$HOME/.virtualenvs
VIRTUALENV_WRAPPER=/usr/local/bin/virtualenvwrapper.sh

if [ ! -d $WORKON_HOME ];
then
  mkdir $WORKON_HOME
fi

if [ -f $VIRTUALENV_WRAPPER ];
then
  . $VIRTUALENV_WRAPPER
fi

#  1. Create a directory to hold the virtual environments.
#     (mkdir $HOME/.virtualenvs).
#  2. Add a line like "export WORKON_HOME=$HOME/.virtualenvs"
#     to your .bashrc.
#  3. Add a line like "source /path/to/this/file/virtualenvwrapper.sh"
#     to your .bashrc.
#  4. Run: source ~/.bashrc
#  5. Run: workon
#  6. A list of environments, empty, is printed.
#  7. Run: mkvirtualenv temp
