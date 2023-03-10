# Build the docker image used to run the scripts
# to continuously update our docker files.
#
# The context for this docker file should be the root of the kubeflow/testing repository.
FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl git python3.8 python3-pip wget && \
    ln -sf /usr/bin/python3.8 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

# Install go
RUN cd /tmp && \
    wget -O /tmp/go.tar.gz https://redirector.gvt1.com/edgedl/go/go1.12.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz

# Install the hub CLI for git
RUN cd /tmp && \
    curl -f -LO https://github.com/github/hub/releases/download/v2.13.0/hub-linux-amd64-2.13.0.tgz && \
    tar -xvf hub-linux-amd64-2.13.0.tgz && \
    mv hub-linux-amd64-2.13.0 /usr/local && \
    ln -sf /usr/local/hub-linux-amd64-2.13.0/bin/hub /usr/local/bin/hub && rm hub-linux-amd64-2.13.0.tgz

RUN export KUSTOMIZE_VERSION=3.2.0 && \
    cd /tmp && \
    curl -f -LO https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 && \
    mv kustomize_${KUSTOMIZE_VERSION}_linux_amd64 /usr/local/bin/kustomize && \
    chmod a+x /usr/local/bin/kustomize

COPY apps-cd/requirements.txt /tmp
RUN python -m pip install \
     -r /tmp/requirements.txt

# Create go symlinks
RUN ln -sf /usr/local/go/bin/go /usr/local/bin && \
    ln -sf /usr/local/go/bin/gofmt /usr/local/bin && \
    ln -sf /usr/local/go/bin/godoc /usr/local/bin

RUN mkdir -p /app

RUN cd /app && \
    mkdir -p /app/src/kubeflow && \
    cd /app/src/kubeflow && \
    git clone  https://github.com/kubeflow/code-intelligence code-intelligence && \
    cd code-intelligence && \
    git checkout db1230d

COPY apps-cd/run_with_auto_restart.py /app
COPY py /app/src/kubeflow/testing/py

ENV PYTHONPATH /app/src/kubeflow/testing/py:/app/src/kubeflow/code-intelligence/py:$PYTHONPATH

# See(https://github.com/tektoncd/pipeline/issues/1271): Tekton will put ssh
# credentials in /tekton/home. We can't change the home directory
# but we can create a symbolic link for .ssh
RUN mkdir -p /tekton/home && \
    ln -sf /tekton/home/.ssh /root/.ssh
