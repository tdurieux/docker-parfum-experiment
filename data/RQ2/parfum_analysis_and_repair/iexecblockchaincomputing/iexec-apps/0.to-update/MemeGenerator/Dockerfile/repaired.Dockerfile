FROM ubuntu:18.04

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
	python3 \
	python3-pip \
	ttf-mscorefonts-installer \
	xvfb \
	wkhtmltopdf \
	zip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir imgkit

COPY src /src
COPY entrypoint.sh /entrypoint.sh
COPY ressources/*.ttf /usr/share/fonts/truetype/.

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
