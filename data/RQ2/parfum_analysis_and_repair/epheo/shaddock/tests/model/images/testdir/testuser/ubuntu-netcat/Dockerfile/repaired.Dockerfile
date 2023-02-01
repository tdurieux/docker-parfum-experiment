FROM ubuntu:16.04
MAINTAINER epheo <github@epheo.eu>

RUN apt update && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

EXPOSE 1235

CMD ["env"]
