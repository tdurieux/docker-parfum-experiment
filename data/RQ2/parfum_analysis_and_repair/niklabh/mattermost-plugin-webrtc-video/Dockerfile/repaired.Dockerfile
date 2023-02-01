FROM golang:1.13

RUN apt update && \
    apt -y --no-install-recommends install build-essential npm && rm -rf /var/lib/apt/lists/*;

RUN addgroup --gid 1000 node \
    && useradd --create-home --uid 1000 --gid node --shell /bin/sh node

CMD /bin/sh
