FROM debian:stable

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        build-essential \
        net-tools \
        python3 \
        python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir -U pip && \
    mkdir /app

COPY . /app

WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8501

CMD ["python3", "-m", "DockerENT", "--web-app"]
