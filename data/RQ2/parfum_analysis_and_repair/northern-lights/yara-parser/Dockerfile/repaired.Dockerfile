FROM golang:1.10

RUN DEBIAN_FRONTEND=noninteractive \
	apt update && apt install --no-install-recommends -y \
		automake \
		bison \
		help2man \
		m4 \
		texinfo \
		texlive && rm -rf /var/lib/apt/lists/*;

RUN go get golang.org/x/tools/cmd/goyacc
RUN go get github.com/pebbe/flexgo/...

ENV FLEXGO=/go/src/github.com/pebbe/flexgo

RUN cd ${FLEXGO} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && cd -
RUN make -C ${FLEXGO} && make -C ${FLEXGO} install