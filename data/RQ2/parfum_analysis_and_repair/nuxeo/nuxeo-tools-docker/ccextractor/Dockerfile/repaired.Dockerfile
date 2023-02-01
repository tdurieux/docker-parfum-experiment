FROM ubuntu:bionic

RUN apt-get update && apt-get -q --no-install-recommends -y install wget unzip cmake libcurl3-openssl-dev libtesseract-dev libleptonica-dev checkinstall && rm -rf /var/lib/apt/lists/*;

COPY files/get-and-build.sh get-and-build.sh
RUN chmod +x get-and-build.sh

ENTRYPOINT ./get-and-build.sh

