FROM debian:8

RUN apt-get update \
		&& apt-get install --no-install-recommends -y \
			curl \
			build-essential \
			libbz2-dev \
			libffi-dev \
			libncurses5-dev \
			libreadline-dev \
			libssl-dev \
			sudo \
			wget \
		&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/
COPY build /opt/build
RUN  bash build

RUN useradd -ms /bin/bash user \
		&& echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

CMD ["/sbin/init"]
