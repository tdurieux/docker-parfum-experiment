FROM library/debian:stable

RUN apt-get update -qq --fix-missing \
  && apt-get install --no-install-recommends -y curl python-pip bind9-host ssh && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://github.com/kubernetes/kops/releases/download/$( curl -f -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
RUN chmod +x kops-linux-amd64
RUN mv kops-linux-amd64 /usr/local/bin/kops

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

RUN pip install --no-cache-dir awscli

WORKDIR /root
