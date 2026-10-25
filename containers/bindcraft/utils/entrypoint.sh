#!/bin/bash
set -e

# BindCraft: share one environment, lockfile and AF2 weights between identical containers.
# The container runs as the submitting uid (Run:ai --run-as-uid): that uid has no passwd entry,
# so HOME may be unwritable and zsh finds no startup file.
BINDCRAFT_SHARED=${BINDCRAFT_SHARED:-/scratch/.envs/bindcraft}
mkdir -p ${BINDCRAFT_SHARED}/.pixi
ln -sfn ${BINDCRAFT_SHARED}/.pixi /bindcraft/.pixi
ln -sfn ${BINDCRAFT_SHARED}/pixi.lock /bindcraft/pixi.lock
ln -sfn ${BINDCRAFT_PARAMS:-/scratch/data/params} /bindcraft/params

if [[ -z ${HOME:-} || ! -w ${HOME} ]]; then
  export HOME=/tmp/$(id -u)
fi
mkdir -p "$HOME"
[[ -e $HOME/.oh-my-zsh ]] || ln -sfn /docker/.oh-my-zsh "$HOME/.oh-my-zsh"
[[ -f $HOME/.zshrc ]] || cp /docker/.zshrc "$HOME/.zshrc"
[[ -f $HOME/.bashrc ]] || cp /docker/.bashrc "$HOME/.bashrc"

cd /bindcraft && pixi install

for d in "${BINDCRAFT_SHARED}"/.pixi/envs/*/lib; do
  [[ -d $d ]] && export LD_LIBRARY_PATH="$d${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
done

exec "$@"
