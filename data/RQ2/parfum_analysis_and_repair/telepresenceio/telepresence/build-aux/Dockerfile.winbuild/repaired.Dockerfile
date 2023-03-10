FROM golang:1.16.5


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg \
            lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io && rm -rf /var/lib/apt/lists/*;