# Docker file specifying  MITRE SSL certificates for a Full Stack CNAB invocation image
FROM ubuntu:latest

ARG BUNDLE_DIR
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update && apt-get install -y ca-certificates && apt-get install -y curl

# RUN curl http://pki.mitre.org/MITRE%20BA%20ROOT.crt >> /etc/ssl/certs/ca-certificates.crt && \
#     curl http://pki.mitre.org/MITRE%20BA%20NPE%20CA-3.crt >> /etc/ssl/certs/ca-certificates.crt && \
#     curl http://pki.mitre.org/MITRE%20BA%20NPE%20CA-4.crt >> /etc/ssl/certs/ca-certificates.crt && \
#     update-ca-certificates

# WORKDIR /pki
# COPY Zscaler_Root_CA.pem .
# RUN cat Zscaler_Root_CA.pem >> /etc/ssl/certs/ca-certificates.crt



# # Install Git from Source to get around TLS errors with Zscaler,
# # explicitly using openssl instead of gnutls
# # RUN cp /etc/apt/sources.list /etc/apt/sources.list~
# RUN sed -i -- 's/# deb-src/deb-src/' /etc/apt/sources.list
# RUN apt-get update && \
#     apt-get install build-essential fakeroot dpkg-dev -y && \
#     apt-get install git-man -y && \
#     apt-get -f build-dep git -y && \
#     apt-get install libcurl4-openssl-dev -y

# WORKDIR /sourcegit

# RUN apt-get source git && \
#     cd git-2.*.*/ && \
#     sed -i -- 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/' ./debian/control && \
#     sed -i -- '/TEST\s*=\s*test/d' ./debian/rules && \
#     dpkg-buildpackage -rfakeroot -b -uc -us && \
#     dpkg -i ../git_*ubuntu*.deb