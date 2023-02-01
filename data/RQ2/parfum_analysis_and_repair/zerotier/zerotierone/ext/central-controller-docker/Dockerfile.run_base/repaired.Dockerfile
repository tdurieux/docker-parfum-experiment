FROM ubuntu:jammy
RUN apt update && apt upgrade -y
RUN apt -y --no-install-recommends install \
    postgresql-client \
    postgresql-client-common \
    libjemalloc2 \
    libpq5 \
    curl && rm -rf /var/lib/apt/lists/*;
