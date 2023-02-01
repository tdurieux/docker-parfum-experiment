FROM nvidia/cuda:10.0-devel-ubuntu18.04 as build_stage

ENV GO_VERSION 1.12
ENV GO_ARCH 'linux-amd64'
ENV GO_BIN_SHA '750a07fef8579ae4839458701f4df690e0b20b8bcce33b437e4df89c451b6f13'


#  Install required dev tools to compile cyberd
###############################################################################
RUN apt-get update && apt-get install -y --no-install-recommends wget git


#  Install golang
###############################################################################
RUN url="https://golang.org/dl/go${GO_VERSION}.${GO_ARCH}.tar.gz" && \
	wget -O go.tgz "$url" && \
	echo "${GO_BIN_SHA} *go.tgz" | sha256sum -c - && \
	tar -C /usr/local -xzf go.tgz &&\
	rm go.tgz

ENV PATH="/usr/local/go/bin:$PATH"
RUN go version && nvcc --version


# Compile cuda kernel
###############################################################################
COPY . /sources
WORKDIR /sources/x/rank/cuda
RUN nvcc -fmad=false -shared -o libcbdrank.so rank.cu --compiler-options '-fPIC -frounding-math -fsignaling-nans' && \
    cp libcbdrank.so /usr/lib/ && cp cbdrank.h /usr/lib/


# Compile cyberd
###############################################################################
WORKDIR /sources
RUN go build -tags cuda -o cyberd ./daemon
RUN go build -o cyberdcli ./cli


###############################################################################
# Create base image
###############################################################################
FROM nvidia/cuda:10.0-runtime-ubuntu18.04

#  Install useful dev tools
###############################################################################
RUN apt-get update && apt-get install -y --no-install-recommends wget curl

#  Download genesis file and links file from IPFS
###############################################################################
# To slow using ipget, currently we use gateway
RUN wget -O /genesis.json https://ipfs.io/ipfs/Qmd6vJaBMkQryo9e4QvY6pHMSPin3PHAwjNqmnYE1E2qPn
RUN wget -O /links https://ipfs.io/ipfs/QmYXsdxeHRA12jZh9tmDuff4rth4hergzMxhMAX7niGhAs
RUN wget -O /config.toml https://ipfs.io/ipfs/Qmc8shUKgXREq45bYFezK5iNUVmRYGVdkiYijC9pmRisHc

WORKDIR /

#  Copy compiled kernel and binaries
###############################################################################
COPY --from=build_stage /sources/cyberd /usr/bin/cyberd
COPY --from=build_stage /sources/cyberdcli /usr/bin/cyberdcli

COPY --from=build_stage /usr/lib/cbdrank.h /usr/lib/cbdrank.h
COPY --from=build_stage /usr/lib/libcbdrank.so /usr/lib/libcbdrank.so

#  Copy startup scripts
###############################################################################

COPY start_script.sh start_script.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x start_script.sh
RUN chmod +x /entrypoint.sh


#  Start
###############################################################################
EXPOSE 26656 26657
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./start_script.sh"]
