FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends curl git wget -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
RUN mkdir -p ~/.helm/plugins/
RUN cd ~/.helm/plugins/ && git clone https://github.com/app-registry/appr-helm-plugin.git registry && cd -
RUN helm registry --help
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin/
RUN wget https://github.com/app-registry/appr/releases/download/v0.7.2/appr-linux-x64
RUN chmod +x appr-linux-x64
RUN mv ./appr-linux-x64 /usr/bin/appr

