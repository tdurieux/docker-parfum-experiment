FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y git zsh nano vim wget curl screen && \
			sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

CMD [ "zsh" ]