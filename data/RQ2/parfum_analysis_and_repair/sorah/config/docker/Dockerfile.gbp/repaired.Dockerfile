FROM debian:buster
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git-buildpackage git-core && rm -rf /var/lib/apt/lists/*;
RUN mkdir /home/sorah
RUN chmod 755 /home/sorah
