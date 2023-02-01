FROM debian:stretch-slim
RUN apt-get update && \
    apt-get install --no-install-recommends -y bash zsh ksh ruby ruby-dev git build-essential && \
    git clone git://github.com/thinkerbot/ronn.git /tmp/ronn && \
    cd /tmp/ronn && \
    rake install && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . /app
