FROM docker-registry.wikimedia.org/nodejs12-devel

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		ca-certificates \
		git && rm -rf /var/lib/apt/lists/*;

ARG UID=1000
ARG GID=1000

RUN addgroup --gid $GID runuser && adduser --uid $UID --gid $GID --disabled-password --gecos "" runuser

RUN npm install --global npm@6.14.16 && npm cache clean --force;

USER runuser
