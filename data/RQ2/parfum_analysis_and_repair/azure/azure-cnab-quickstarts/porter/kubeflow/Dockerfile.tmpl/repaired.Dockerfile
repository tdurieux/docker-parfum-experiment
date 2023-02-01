FROM debian:stretch

ARG BUNDLE_DIR

ENV KUBEFLOW_REPO=https://github.com/kubeflow/kubeflow
ENV KUBEFLOW_VERSION=v1.0
ENV KFCTL_VERSION=v1.0-0-g94c35cf
ENV TOOLHOME="/usr/bin"

COPY . $BUNDLE_DIR

RUN apt-get update && apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN wget ${KUBEFLOW_REPO}/releases/download/${KUBEFLOW_VERSION}/kfctl_${KFCTL_VERSION}_linux.tar.gz
RUN tar -xvf kfctl_${KFCTL_VERSION}_linux.tar.gz -C ${TOOLHOME} && chmod +x "${TOOLHOME}/kfctl" && rm kfctl_${KFCTL_VERSION}_linux.tar.gz

WORKDIR $BUNDLE_DIR
RUN chmod +x kubeflow.sh