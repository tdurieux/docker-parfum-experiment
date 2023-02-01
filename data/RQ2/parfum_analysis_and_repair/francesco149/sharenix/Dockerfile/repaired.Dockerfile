ARG PREFIX=golang
FROM ${PREFIX}:1.11.2-stretch
ARG ARCH=x86_64
ENV arch=${ARCH}
RUN apt-get update && apt-get install --no-install-recommends -y libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;
USER ${username}
CMD setarch ${arch} ./release.sh
