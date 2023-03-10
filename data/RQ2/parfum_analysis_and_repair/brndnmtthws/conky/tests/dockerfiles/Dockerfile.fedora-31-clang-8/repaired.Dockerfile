ARG IMAGE=registry.gitlab.com/brndnmtthws-oss/conky
FROM ${IMAGE}/builder/fedora-31-base:latest

RUN dnf -y -q install \
  llvm \
  clang \
  libcxx-devel \
  libcxxabi-devel \
  npm \
  && dnf clean all \
  && npm cache clean --force