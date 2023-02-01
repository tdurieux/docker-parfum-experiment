FROM openjdk:11-jre
LABEL maintainer "Oliver Kopp <kopp.dev@gmail.com>, Lukas Harzenetter <lharzenetter@gmx.de>"

RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get update && apt-get install --no-install-recommends -y git git-lfs && rm -rf /var/lib/apt/lists/*;

COPY winery-cli.jar /usr/local/bin
COPY docker/winery-cli /usr/local/bin

RUN chmod +x /usr/local/bin/winery-cli

CMD winery-cli
