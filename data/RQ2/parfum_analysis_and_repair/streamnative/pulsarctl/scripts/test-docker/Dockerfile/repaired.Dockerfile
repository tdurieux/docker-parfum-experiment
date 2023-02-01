ARG PULSAR_VERSION
FROM streamnative/pulsar-all:$PULSAR_VERSION

# use root user
USER root

# install golang
ENV GOLANG_VERSION 1.18.1
RUN curl -f -sSL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz \
		| tar -C /usr/local -xz
ENV PATH /usr/local/go/bin:$PATH

# install git
RUN apt update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

# copy the code into image
COPY . /pulsarctl

ENV PULSAR_HOME /pulsar
ENV PULSARCTL_HOME /pulsarctl

ENTRYPOINT /pulsarctl/scripts/entrypoint.sh
