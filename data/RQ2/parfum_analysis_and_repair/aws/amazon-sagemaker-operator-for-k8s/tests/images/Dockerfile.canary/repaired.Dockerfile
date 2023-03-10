FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    wget \
    git \
    python \
    python-pip \
    vim \
    sudo \
    jq && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

# Add yq repository and install yq
RUN apt-get update && apt install --no-install-recommends -y software-properties-common && sudo add-apt-repository ppa:rmescandon/yq && apt update && apt install --no-install-recommends -y yq && rm -rf /var/lib/apt/lists/*;

# Install kubectl
RUN curl -f -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.9/2019-06-21/bin/linux/amd64/kubectl \
      && chmod +x ./kubectl && cp ./kubectl /bin

# Install eksctl
RUN curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /bin

# Install kustomize
RUN curl -f -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.2.1/kustomize_kustomize.v3.2.1_linux_amd64 && mv kustomize_kustomize.v3.2.1_linux_amd64 /bin/kustomize && chmod u+x /bin/kustomize

# Install dig, used for PrivateLink test.
RUN apt-get install --no-install-recommends -y dnsutils && rm -rf /var/lib/apt/lists/*;

# Set the environment variables
ARG DATA_BUCKET
ENV DATA_BUCKET=$DATA_BUCKET

ARG COMMIT_SHA
ENV COMMIT_SHA=$COMMIT_SHA

ARG RESULT_BUCKET
ENV RESULT_BUCKET=$RESULT_BUCKET

# Set working directory
RUN mkdir -p /app/testfiles
WORKDIR /app/testfiles

COPY codebuild/testfiles/*.yaml ./

WORKDIR /app

COPY codebuild/*.sh ./
RUN chmod +x ./*.sh

COPY sagemaker-k8s-operator.tar.gz .

CMD ["./run_canarytest.sh"]
