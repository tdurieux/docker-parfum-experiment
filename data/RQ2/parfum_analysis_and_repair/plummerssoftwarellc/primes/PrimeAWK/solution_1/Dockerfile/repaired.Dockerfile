FROM ubuntu:20.04

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential mawk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/primes

COPY primes.awk counts.csv ./

ENTRYPOINT ["mawk",  "-f", "primes.awk", "-F", ",", "counts.csv"]
