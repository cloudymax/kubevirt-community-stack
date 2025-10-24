FROM debian:bookworm

ENV NONINTERACTIVE=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y cloud-init \
    git \
    whois \
    gettext-base \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    bc \
    golang-petname \
    jq

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && apt-get update \
    && apt-get install -y kubectl

RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
    && wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${arch} -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

ARG USER="appuser"

RUN useradd -ms /bin/bash $USER \
    && mkdir -p /home/$USER/.local/bin \
    && mkdir -p /home/$USER/.local/lib

RUN chmod +x /home/$USER/cigen.sh \
    && chmod +x /home/$USER/secretgen.sh \
    && sudo chown -R $USER:$USER /home/$USER \
    && sudo chmod -R u+rw /home/$USER

WORKDIR /home/$USER

USER 1000

ENTRYPOINT [ "/bin/bash", "/home/appuser/cigen.sh" ]
