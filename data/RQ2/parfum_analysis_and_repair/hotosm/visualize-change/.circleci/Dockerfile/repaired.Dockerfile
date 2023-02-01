from ubuntu:latest

RUN apt update && \
    apt install --no-install-recommends -y python-dev python-pip apt-transport-https \
      ca-certificates curl software-properties-common && \
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" && \
    apt update && apt install --no-install-recommends -y docker-ce && \
    pip install --no-cache-dir docker-compose awscli==1.11.76 && rm -rf /var/lib/apt/lists/*;
