ARG version=ruby:latest
FROM $version

# Needed for jruby
RUN apt-get update \
    && apt-get install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;

COPY prism/prism/nginx/cert.crt /usr/local/share/ca-certificates/cert.crt
RUN update-ca-certificates

WORKDIR /app
COPY . .

RUN make install
