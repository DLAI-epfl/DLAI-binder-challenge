FROM --platform=amd64 nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04
LABEL maintainer="Noa Ette <noa.ette@epfl.ch>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bzip2 \
    ca-certificates \
    cmake \
    curl \
    git \
    htop \
    libssl-dev \
    libffi-dev \
    locales \
    openssh-server \
    openssh-client \
    rsync \
    sudo \
    tmux \
    screen \
    unzip \
    vim \
    wget \
    zsh \
    python3 \
    python3-pip \
    keychain \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN chsh -s /bin/zsh root

RUN echo "PATH=${PATH}" >> /etc/environment && \
    echo "TF_FORCE_GPU_ALLOW_GROWTH=true" >> /etc/environment

# Pixi binary for all users (project envs still live on scratch via pixi.toml paths).
ENV PIXI_HOME=/opt/pixi
RUN curl -fsSL https://pixi.sh/install.sh | env PIXI_HOME=/opt/pixi PIXI_NO_PATH_UPDATE=1 bash
ENV PATH="/opt/pixi/bin:${PATH}"
RUN echo 'export PATH="/opt/pixi/bin:${PATH}"' > /etc/profile.d/pixi.sh

RUN echo 'root:root' | chpasswd

RUN mkdir /docker
COPY utils/* /docker/
RUN chmod +x /docker/*.sh

CMD ["/bin/zsh"]

RUN cp -r /root/.oh-my-zsh/ /docker/.oh-my-zsh/
RUN cp /root/.zshrc /docker/.zshrc
RUN cp /root/.bashrc /docker/.bashrc
RUN cp /root/.profile /docker/.profile
RUN echo "umask 007" >> /docker/.zshrc && \
    echo "umask 007" >> /docker/.bashrc && \
    echo 'export PATH="/opt/pixi/bin:${PATH}"' >> /docker/.zshrc

RUN git clone https://github.com/martinpacesa/BindCraft /bindcraft
RUN chmod +x /bindcraft/functions/dssp /bindcraft/functions/DAlphaBall.gcc
WORKDIR /bindcraft
COPY pixi.toml /bindcraft

# The container runs as the submitting user (Run:ai --run-as-uid), and the entrypoint creates
# the .pixi / pixi.lock / params symlinks inside the checkout, so the directory must be writable.
RUN chmod a+w /bindcraft

ENTRYPOINT ["/docker/entrypoint.sh"]
