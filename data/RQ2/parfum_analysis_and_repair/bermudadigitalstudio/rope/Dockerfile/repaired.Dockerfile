# A Dockerfile for running Rope unit tests on a Linux environment.
FROM swift:4

RUN apt-get update -q && \
    apt-get install --no-install-recommends -yq pkg-config libpq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /code

COPY Package.swift /code/Package.swift
RUN swift package fetch

# Assuming that tests change less than code, so put Tests before Sources copy
COPY ./Tests /code/Tests
COPY ./Sources /code/Sources
CMD swift test
