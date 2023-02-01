from ubuntu:focal

RUN apt update && apt dist-upgrade -y
# we need to setup tzdata otherwise focal ask for time zone
RUN DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Berlin \
    apt --no-install-recommends \
    install -y build-essential cmake git-core libbz2-dev \
    libmariadb-dev libmariadbclient-dev libmariadb-dev-compat \
    libssl-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

ENTRYPOINT /bin/bash