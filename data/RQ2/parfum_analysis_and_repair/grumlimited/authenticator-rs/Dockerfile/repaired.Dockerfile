FROM library/rust:1.51.0-slim-buster

RUN apt-get update && \
	apt-get install --no-install-recommends -y make bash-completion gcc \
		make \
		libsqlite3-dev \
		libgtk-3-dev \
		openssl \
		libssl-dev \
		python3 \
		python3-pip \
		python3-setuptools \
		python3-wheel \
		ninja-build \
		gettext && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir meson \
	mkdir -p ~/.cargo/release

WORKDIR /authenticator-rs

ENTRYPOINT ["/bin/sleep", "60000"]

