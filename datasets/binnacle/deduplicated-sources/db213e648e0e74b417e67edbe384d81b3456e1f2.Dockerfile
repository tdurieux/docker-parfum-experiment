# Maybe switch to one of the Google-provided images? But seems to be go 1.8, not 1.10:
# https://cloud.google.com/appengine/docs/flexible/custom-runtimes/build#base
FROM golang:1.11

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["dumb-init", "--"]

RUN groupadd -r amppkg && useradd --no-log-init -r -g amppkg amppkg
WORKDIR /amppkg

COPY amppkg.toml /amppkg
# Copy whatever certs are available in the certs/ directory (both encrypted and
# unencrypted) into the container. (./decrypt.sh will NOOP if any *.pem exist.)
COPY certs/*pem* /amppkg/
COPY decrypt.sh /amppkg

RUN chmod +x /amppkg/decrypt.sh
RUN chown -R amppkg:amppkg /amppkg

# Install the AMP packager
RUN go get github.com/ampproject/amppackager/cmd/amppkg

USER amppkg
EXPOSE 8080
CMD [ "bash", "-c", "./decrypt.sh && exec amppkg -config /amppkg/amppkg.toml" ]
