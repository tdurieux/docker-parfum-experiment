FROM python:latest
MAINTAINER Julian-Samuel Gebühr

RUN apt-get update && apt-get install --no-install-recommends -y pip && rm -rf /var/lib/apt/lists/*;
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir matrix-registration-bot
VOLUME ["/data"]
WORKDIR /data
CMD ["matrix-registration-bot"]
