FROM python:2.7.15-slim-stretch

MAINTAINER Newnius <newnius.cn@gmail.com>

WORKDIR /root

RUN apt-get update \
        && apt-get install --no-install-recommends -y wget \
        && wget -O dropbox.tgz "https://www.dropbox.com/download?plat=lnx.x86_64" \
        && tar xzf dropbox.tgz \
        && rm dropbox.tgz && rm -rf /var/lib/apt/lists/*;

RUN wget -O dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py" \
	&& chmod +x dropbox.py

ENTRYPOINT ["/root/.dropbox-dist/dropboxd"]
