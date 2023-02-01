FROM ubuntu:20.04
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential wcslib-dev

# Source files
COPY src/ /app/src/
COPY compile.sh sofia.c /app/

# Install sofia
RUN ./compile.sh -fopenmp && \
    ln -s /app/sofia /usr/bin/sofia

ENTRYPOINT ["sofia"];
