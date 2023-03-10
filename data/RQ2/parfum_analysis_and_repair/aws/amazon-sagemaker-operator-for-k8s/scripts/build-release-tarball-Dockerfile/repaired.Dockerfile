# Build the release tarball. MacOS default tar creates extra tar headers which produce annoying
# stderr output. By controlling the build environment we improve the experience for end-users.
#
FROM alpine:latest

RUN mkdir -p sagemaker-k8s-operator-install-scripts
WORKDIR /sagemaker-k8s-operator-install-scripts

COPY ./README.md README.md
COPY ./config config

WORKDIR /
RUN tar -czvf sagemaker-k8s-operator-install-scripts.tar.gz sagemaker-k8s-operator-install-scripts && rm sagemaker-k8s-operator-install-scripts.tar.gz
