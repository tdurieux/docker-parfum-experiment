FROM debian

RUN apt update -y && \
	apt install -y --no-install-recommends curl wget ca-certificates tar gzip && \
	apt clean && \
	rm -rf /var/lib/apt/lists/ && \
	echo done && rm -rf /var/lib/apt/lists/*;
