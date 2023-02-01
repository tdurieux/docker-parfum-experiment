FROM golang:1.12

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get install -y -qq postgresql-11 unzip

RUN rm /etc/postgresql/11/main/pg_hba.conf; \
	echo 'local   all             all                                     trust' >> /etc/postgresql/11/main/pg_hba.conf; \
	echo 'host    all             all             127.0.0.1/8             trust' >> /etc/postgresql/11/main/pg_hba.conf; \
	echo 'host    all             all             ::1/128                 trust' >> /etc/postgresql/11/main/pg_hba.conf; \
	echo 'host    all             all             ::0/0                   trust' >> /etc/postgresql/11/main/pg_hba.conf;

RUN echo 'max_connections = 1000' >> /etc/postgresql/11/main/conf.d/connectionlimits.conf

COPY ./scripts/install-awscli.sh /tmp/install-awscli.sh
RUN bash /tmp/install-awscli.sh
ENV PATH "$PATH:/root/bin"

RUN curl -L https://github.com/google/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip -o /tmp/protoc.zip
RUN unzip /tmp/protoc.zip -d "$HOME"/protoc

RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b ${GOPATH}/bin v1.17.1
RUN go get github.com/ckaznocha/protoc-gen-lint
RUN go get github.com/nilslice/protolock/cmd/protolock
RUN go get github.com/mfridman/tparse
RUN go get github.com/josephspurrier/goversioninfo

RUN go get github.com/axw/gocov/gocov
RUN go get github.com/AlekSi/gocov-xml

RUN go get -v -u github.com/loov/leakcheck

RUN go version