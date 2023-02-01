ARG go_version
FROM golang:${go_version}-buster

RUN apt update \
    && apt install --no-install-recommends -y libhivex-dev libhivex-bin libwin-hivex-perl && rm -rf /var/lib/apt/lists/*;

COPY . /src

WORKDIR /src

RUN go generate ./ \
    && go test -parallel=1 -count=1 -v . \
    && go install .

ENTRYPOINT ["/go/bin/bcdhive_gen"]
