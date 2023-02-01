FROM mup-tests-server
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y docker-ce docker-ce-cli containerd.io --option=Dpkg::Options::=--force-confdef >/dev/null && rm -rf /var/lib/apt/lists/*;
RUN echo 'DOCKER_OPTS="--storage-driver=vfs"' >> /etc/default/docker
