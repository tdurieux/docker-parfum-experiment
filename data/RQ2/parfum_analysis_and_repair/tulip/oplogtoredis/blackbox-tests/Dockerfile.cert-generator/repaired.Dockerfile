from ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends openssl -y && rm -rf /var/lib/apt/lists/*;
WORKDIR generate-certificates
COPY generate-certificates.sh ./generate-certificates.sh
CMD ./generate-certificates.sh \
  && cp -f server-cert.pem /shared-volume/server-cert.pem \
  && cp -f server-key.pem /shared-volume/server-key.pem \
  && cp -f ca.pem /shared-volume/ca.crt
