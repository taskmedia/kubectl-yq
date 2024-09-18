FROM bitnami/kubectl

# Image annotations
# see: https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title=kubectl-yq
LABEL org.opencontainers.image.description="image with kubectl and yq installed"
LABEL org.opencontainers.image.url=https://github.com/taskmedia/kubectl-yq/pkgs/container/kubectl-yq
LABEL org.opencontainers.image.source=https://github.com/taskmedia/kubectl-yq/blob/main/Dockerfile
LABEL org.opencontainers.image.vendor=task.media
LABEL org.opencontainers.image.licenses=MIT

USER root

RUN apt update &&  apt install wget

RUN LATEST_VERSION=$(wget -O- --quiet https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.tag_name') && \
  wget "https://github.com/mikefarah/yq/releases/download/${LATEST_VERSION}/yq_linux_$(dpkg --print-architecture).tar.gz" -O - |\
  tar xz && mv yq_linux_* /usr/bin/yq

USER 1001

# print versions
RUN kubectl version --client=true && yq --version
