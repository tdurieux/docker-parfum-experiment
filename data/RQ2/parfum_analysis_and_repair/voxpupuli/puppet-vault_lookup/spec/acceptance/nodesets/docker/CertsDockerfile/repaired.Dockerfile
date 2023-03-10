FROM alpine:3.9


# Install openssl
RUN apk update && apk add --no-cache openssl

# Setup cert infrastructure on the machine

RUN mkdir /root/ca
WORKDIR /root/ca
COPY spec/acceptance/fixtures/root_ca_openssl.cnf /root/ca/openssl.cnf

RUN mkdir certs crl newcerts private \
  && touch index.txt \
  && echo 1000 > serial
RUN echo 1000 > /root/ca/crlnumber

RUN openssl genrsa -out private/rootca.key.pem 4096
RUN openssl req -config openssl.cnf \
  -key private/rootca.key.pem \
  -new -x509 -days 7300 -sha256 -extensions v3_ca \
  -subj "/CN=rootca" \
  -out certs/rootca.cert.pem

RUN mkdir /root/ca/intermediate
COPY spec/acceptance/fixtures/intermediate_ca_openssl.cnf /root/ca/intermediate/openssl.cnf

WORKDIR /root/ca/intermediate/
RUN mkdir certs crl csr newcerts private \
  && touch index.txt \
  && echo 1000 > serial
RUN echo 1000 > /root/ca/intermediate/crlnumber

WORKDIR /root/ca
RUN openssl genrsa -out intermediate/private/intermediate.key.pem 4096
RUN openssl req -config intermediate/openssl.cnf -new -sha256 \
      -key intermediate/private/intermediate.key.pem \
      -subj "/CN=intermediateca" \
      -out intermediate/csr/intermediate.csr.pem

RUN openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -batch -notext -md sha256 \
      -in intermediate/csr/intermediate.csr.pem \
      -out intermediate/certs/intermediate.cert.pem

RUN cat  intermediate/certs/intermediate.cert.pem certs/rootca.cert.pem \
      > intermediate/certs/ca-bundle.cert.pem

RUN openssl genrsa -out intermediate/private/vault.key.pem 2048
RUN openssl req -config intermediate/openssl.cnf \
      -key intermediate/private/vault.key.pem \
      -subj "/CN=vault.local" \
      -addext "subjectAltName = DNS:vault.local" \
      -new -sha256 -out intermediate/csr/vault.csr.pem
RUN openssl ca -config intermediate/openssl.cnf \
      -extensions server_cert -days 375 -batch -notext -md sha256 \
      -in intermediate/csr/vault.csr.pem \
      -out intermediate/certs/vault.cert.pem

RUN openssl ca -config intermediate/openssl.cnf \
      -gencrl -out intermediate/crl/intermediate.crl.pem

RUN openssl ca -config openssl.cnf \
      -gencrl -out crl/rootca.crl.pem

RUN cat intermediate/crl/intermediate.crl.pem crl/rootca.crl.pem > intermediate/crl/crlchain.pem

CMD tail -f /dev/null
