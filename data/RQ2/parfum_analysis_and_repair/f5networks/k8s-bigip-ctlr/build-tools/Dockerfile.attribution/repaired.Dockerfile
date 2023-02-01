FROM golang:1.15
COPY . .
RUN apt-get update && apt-get install --no-install-recommends -y ruby bundler cmake pkg-config git libssl-dev libpng-dev && \
    gem install licensee && rm -rf /var/lib/apt/lists/*;
RUN $PWD/build-tools/attributions-generator.sh "$PWD/vendor"