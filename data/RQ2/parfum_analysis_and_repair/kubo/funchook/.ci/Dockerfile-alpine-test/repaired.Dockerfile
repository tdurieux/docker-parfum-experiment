FROM alpine
RUN apk add --no-cache musl-dev gcc g++ make cmake git
COPY . /funchook
ENTRYPOINT ["/funchook/.ci/run-cmake-test.sh", "alpine"]
