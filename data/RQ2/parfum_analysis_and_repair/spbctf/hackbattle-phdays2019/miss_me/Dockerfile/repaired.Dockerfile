FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --no-install-recommends -yq socat util-linux && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY miss_me_server run.sh ./

RUN chmod +x run.sh && chmod +x miss_me_server

CMD ["./run.sh"]


