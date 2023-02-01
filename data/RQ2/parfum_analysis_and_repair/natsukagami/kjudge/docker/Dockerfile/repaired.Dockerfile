# Stage 0: Compile isolate
FROM ubuntu:focal AS isolate

RUN apt-get update && apt-get install --no-install-recommends -y libcap-dev gcc git make && rm -rf /var/lib/apt/lists/*;

WORKDIR /isolate

RUN git clone --branch v1.8.1 --single-branch https://github.com/ioi/isolate.git .

RUN make isolate

# Stage 1: Generate front-end
FROM node:14-buster AS frontend

# Install node-gyp requirements
RUN apt-get install -y --no-install-recommends python3 make g++ && rm -rf /var/lib/apt/lists/*;

COPY ./ /kjudge

WORKDIR /kjudge/frontend

RUN yarn && yarn --prod --frozen-lockfile build && yarn cache clean;

# Stage 3: Build back-end
FROM golang:1.14-buster AS backend

WORKDIR /kjudge

COPY go.mod go.sum ./
RUN go mod download

COPY --from=frontend /kjudge/. /kjudge

RUN scripts/install_tools.sh
RUN sed -i 's/^debug/# debug/' fileb0x.yaml
RUN go generate && go build -tags production -o kjudge cmd/kjudge/main.go

# Stage 4: Create awesome output image
FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Asia/Ho_Chi_Minh" apt-get --no-install-recommends install -y \
    build-essential openjdk-8-jdk-headless fp-compiler python3.6 cgroup-lite python2.7 rustc golang libcap-dev \
    openssl && rm -rf /var/lib/apt/lists/*;

COPY --from=isolate /isolate/ /isolate

WORKDIR /isolate
RUN make install

COPY --from=backend /kjudge/kjudge /usr/local/bin
COPY --from=backend /kjudge/scripts /scripts

RUN ln -s /usr/bin/python2.7 /usr/bin/python2

VOLUME ["/data", "/certs"]

EXPOSE 80 443

WORKDIR /
ENTRYPOINT ["scripts/start_container.sh"]

