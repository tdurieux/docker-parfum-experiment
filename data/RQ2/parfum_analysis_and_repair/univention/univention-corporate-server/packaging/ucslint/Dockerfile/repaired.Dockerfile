ARG ucs=latest
FROM docker-registry.knut.univention.de/phahn/ucs-minbase:$ucs
ENV LANG C.UTF-8
RUN apt-get -qq update && \
	apt-get -qq -y install --no-install-recommends ca-certificates devscripts python-flake8 python3-apt python3-debian python3-flake8 python3-junit.xml && \
	find /var/lib/apt/lists /var/cache/apt/archives -not -name lock -type f -delete && rm -rf /var/lib/apt/lists/*;
COPY . /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/ucslint"]
