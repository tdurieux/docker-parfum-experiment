FROM debian:latest

# prereqs
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        puredata \
        vim && rm -rf /var/lib/apt/lists/*;

# actual code
RUN git clone https://github.com/gabochi/rampcode.git /opt/rampcode

WORKDIR /opt/rampcode

CMD ./rampcode.sh
