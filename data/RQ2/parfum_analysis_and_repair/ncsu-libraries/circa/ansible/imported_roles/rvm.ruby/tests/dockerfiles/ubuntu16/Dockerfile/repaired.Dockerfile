FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
			curl \
			python \
			sudo \
		&& rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash user \
		&& echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

CMD ["/sbin/init"]
