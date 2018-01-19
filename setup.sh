#!/usr/bin/env bash

function requirements() {
  echo "* Python 2.7 or above."
  echo "* PyPI for Python package management."
}

which python
if [[ $? -gt 0 ]]
then
  echo "Missing Python executable on PATH."
  requirements
  exit 1
fi 

which pip
if [[ $? -gt 0 ]]
then
  echo "Missing pip executable on PATH (you may need to link pip3 to pip)."
  requirements
  exit 2
fi 

which virtualenv
if [[ $? -gt 0 ]]
then
  pip install --upgrade --user virtualenv
fi

# Install doom-py build dependencies.
doom_deps_ok=0
# Attempt with Homebrew.
which brew
if [[ $? -eq 0 ]]
then
  pkg_mgr="Homebrew"
  brew install boost boost-python sdl2
  doom_deps_ok=1
fi
# Attempt with MacPorts (exclusive with Homebrew).
which port
if [[ $? -eq 0 ]]
then
  pkg_mgr="MacPorts"
  sudo port install boost libsdl2
  doom_deps_ok=1
fi

if [[ $doom_deps_ok -eq 0 ]]
then
  echo "Failed to install dependencies with $pkg_mgr. Need for manual operations..."
  exit 3
fi

# Get doom-py for custom build (it seems the current version is broken).
#if [[ ! -d doom-py ]]
#then
#  git clone git@github.com:openai/doom-py.git
#  pushd doom-py
#  git checkout a242ce7417a8b65a2cfd18bf616a51ac28b1ed02
#  python setup.py build
#  popd
#fi

set -e

echo "--- Welcome to Deep Reinforcement Learning in TensorFlow ---"
echo "------------------------------------------------------------"
echo "--- By Taehoon Kim, inspired by the fantastic NN community  "
echo
echo "Setting you up with Virtualenv..."

virtualenv venv
source ./venv/bin/activate
pip install -r requirements.txt
deactivate

echo "Setup complete."
echo
echo "Usage: Activate your runtime environment, then run one of the supported networks."
echo
echo "Example:"
echo "source ./venv/bin/activate"
echo "python main.py --double_q=True --env_name=Breakout-v0"
echo
echo "Note: No support for Doom yet (build problem)."
