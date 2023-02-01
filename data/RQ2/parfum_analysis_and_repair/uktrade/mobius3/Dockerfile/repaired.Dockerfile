FROM alpine:3.10

COPY requirements.txt /app/
RUN \
	apk add --no-cache \
		python3 && \
	pip3 install --no-cache-dir \
		-r /app/requirements.txt

COPY LICENSE README.md mobius3.py setup.py /app/
RUN \
	pip3 install --no-cache-dir /app && \
	pip3 check

RUN \
	addgroup -S mobius3 && \
	adduser -S mobius3 -G mobius3
USER mobius3

RUN mkdir /home/mobius3/data

WORKDIR /home/mobius3
