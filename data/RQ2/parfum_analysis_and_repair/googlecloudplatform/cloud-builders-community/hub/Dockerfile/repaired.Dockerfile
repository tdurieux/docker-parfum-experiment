FROM gcr.io/cloud-builders/git

RUN apt-get update && \
  apt-get install --no-install-recommends -y wget && \
  wget https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz && \
  tar xvfz hub-linux-amd64-2.14.2.tgz && \
  rm hub-linux-amd64-2.14.2.tgz && \
  mv hub-linux-amd64-2.14.2/bin/hub /usr/bin/ && \
  chmod +x /usr/bin/hub && \
  alias git=hub && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/hub"]
