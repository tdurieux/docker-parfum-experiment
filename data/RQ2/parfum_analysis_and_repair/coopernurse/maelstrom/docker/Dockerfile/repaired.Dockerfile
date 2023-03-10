FROM golang:1.11-stretch

# install docker
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
         apt-transport-https \
         ca-certificates \
         curl \
         gnupg2 \
         software-properties-common && \
    bash -c 'curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -' && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update && \
    apt-get install --no-install-recommends -y docker-ce libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

