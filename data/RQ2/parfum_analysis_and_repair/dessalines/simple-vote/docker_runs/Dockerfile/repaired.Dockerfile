FROM openjdk:8-jre-slim
USER root
WORKDIR /opt/
RUN apt-get update && apt-get install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://api.github.com/repos/dessalines/simple-vote/releases/latest | grep browser_download_url | cut -d '"' -f 4 | xargs wget