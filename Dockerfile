FROM alpine:3.20

# Image annotations
# see: https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title=kubectl-yq
LABEL org.opencontainers.image.description="image with kubectl and yq installed"
LABEL org.opencontainers.image.url=https://github.com/taskmedia/kubectl-yq/pkgs/container/kubectl-yq
LABEL org.opencontainers.image.source=https://github.com/taskmedia/kubectl-yq/blob/main/Dockerfile
LABEL org.opencontainers.image.vendor=task.media
LABEL org.opencontainers.image.licenses=MIT

ENV KUBECTL_VERSION=v0.34.1

# Download and install kubectl
RUN apk add --no-cache curl ca-certificates bash \
  && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && rm kubectl

RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.tag_name') \
  && curl -L "https://github.com/mikefarah/yq/releases/download/${LATEST_VERSION}/yq_linux_$(dpkg --print-architecture).tar.gz" \
  | tar xz \
  && mv yq_linux_* /usr/bin/yq

USER 65534 # nobody

# print versions
RUN kubectl version --client && yq --version
