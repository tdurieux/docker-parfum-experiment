FROM swift:5.0

WORKDIR /code
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q --no-install-recommends install -y \
    openssl libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY Package.swift /code/.
RUN swift package resolve
COPY ./Sources /code/Sources
COPY ./Tests /code/Tests

RUN swift build