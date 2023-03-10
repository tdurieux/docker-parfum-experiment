ARG IMAGE=registry.gitlab.com/brndnmtthws-oss/conky
FROM ${IMAGE}/builder/fedora-33-base:latest

RUN dnf -y -q install \
  clang \
  gcovr \
  libcxx-devel \
  libcxxabi-devel \
  llvm \
  npm \
  && dnf clean all \
  && npm install -g lcov-summary \
  && npm cache clean --force