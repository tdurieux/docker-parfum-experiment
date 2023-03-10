FROM debian:9-slim

MAINTAINER Newnius <newnius.cn@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends curl unzip man-db -y && \
	curl -f https://rclone.org/install.sh | bash && \
	rm -rf /var/lib/apt/lists/*

ADD bootstrap.sh /etc/bootstrap.sh
ADD sync.sh /etc/sync.sh

CMD ["/etc/bootstrap.sh"]
