FROM python:3.6-buster
LABEL maintainer="codyzacharias@pm.me"

WORKDIR /root

RUN git clone --depth=1 https://github.com/twintproject/twint.git && \
	cd /root/twint && \
	pip3 install --no-cache-dir . -r requirements.txt

CMD /bin/bash
