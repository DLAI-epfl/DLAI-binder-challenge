#!/bin/bash
set -e

if [[ -z $NB_USER ]] || [[ -z $NB_UID ]] || [[ -z $NB_GROUP ]] || [[ -z $NB_GID ]] || [[ -z $WORKING_DIR ]]; then
  # BindCraft: share one environment, lockfile and AF2 weights between identical containers
  BINDCRAFT_SHARED=${BINDCRAFT_SHARED:-/scratch/.envs/bindcraft}
  ln -sfn ${BINDCRAFT_SHARED}/.pixi /bindcraft/.pixi
  ln -sfn ${BINDCRAFT_SHARED}/pixi.lock /bindcraft/pixi.lock
  ln -sfn ${BINDCRAFT_PARAMS:-/scratch/data/params} /bindcraft/params
  cd /bindcraft && pixi install
  exec "$@"
  exit
fi

su - root <<! >/dev/null 2>&1
root
groupadd $NB_GROUP -g $NB_GID
useradd -M -s /bin/bash -N -u $NB_UID -g $NB_GID $NB_USER
echo "${NB_USER}:${NB_USER}" | chpasswd
usermod -aG sudo,adm,root ${NB_USER}
mkdir -p /home/${NB_USER}
chown ${NB_USER}:$NB_GROUP /home/${NB_USER}
echo "${NB_USER}   ALL=(ALL:ALL) ALL" >> /etc/sudoers
chsh -s /bin/zsh ${NB_USER}
rm -rf /home/${NB_USER}/.zshrc
!

mkdir -p ${WORKING_DIR}
#
# BindCraft: share one environment, lockfile and AF2 weights between identical containers
BINDCRAFT_SHARED=${BINDCRAFT_SHARED:-/scratch/.envs/bindcraft}
ln -sfn ${BINDCRAFT_SHARED}/.pixi /bindcraft/.pixi
ln -sfn ${BINDCRAFT_SHARED}/pixi.lock /bindcraft/pixi.lock
ln -sfn ${BINDCRAFT_PARAMS:-/scratch/data/params} /bindcraft/params
cd /bindcraft && pixi install

exec "$@"
