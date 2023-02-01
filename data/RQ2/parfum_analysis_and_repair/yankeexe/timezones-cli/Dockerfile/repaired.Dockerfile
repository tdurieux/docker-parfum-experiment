FROM python:3.9-slim-buster as build

RUN apt-get update && apt install --no-install-recommends -y gcc && \
    useradd -ms /bin/bash tz && rm -rf /var/lib/apt/lists/*;

USER tz

WORKDIR /home/tz

COPY --chown=tz:tz . .

RUN pip install --no-cache-dir --user .

FROM python:3.9-alpine

LABEL description="Get local datetime from multiple timezones!"

RUN apk update && \
    apk upgrade expat libuuid && \
    apk add --no-cache ncurses && \
    rm -rf /var/cache/apk/* && \
    addgroup -S tz && adduser -S tz -u 1000

USER tz

WORKDIR /home/tz

ENV PATH=$PATH:/home/tz/.local/bin

COPY --from=build --chown=tz /home/tz/.local /home/tz/.local/

ENTRYPOINT [ "tz" ]
