FROM --platform=linux/amd64 debian:bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /dist

COPY ./router.rhai .

RUN curl -f -ssL https://router.apollo.dev/download/nix/latest | sh

# for faster docker shutdown
STOPSIGNAL SIGINT

# set the startup command to run your binary
# note: if you want sh you can override the entrypoint using docker run -it --entrypoint=sh my-router-image
ENTRYPOINT ["./router"]

