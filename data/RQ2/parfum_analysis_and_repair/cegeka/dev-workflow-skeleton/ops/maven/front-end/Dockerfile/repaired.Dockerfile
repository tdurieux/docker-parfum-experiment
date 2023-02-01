FROM dws/mvn

RUN apt-get update && \
	apt-get install --no-install-recommends -y bzip2 make g++ && \
	git config --global url."https://".insteadOf git:// && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["cat"]