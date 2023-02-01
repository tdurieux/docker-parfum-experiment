FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y make gcc socat && rm -rf /var/lib/apt/lists/*;

RUN groupadd pilot
RUN useradd pilot --gid pilot

COPY ./app /app
WORKDIR /app

ENTRYPOINT [ "bash", "/app/startService.sh" ]
