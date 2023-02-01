FROM ubuntu:yakkety

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    curl \
	docker.io \
	make \
 && curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install --no-install-recommends -y git-lfs \
 && rm -rf /var/lib/apt/lists/*
