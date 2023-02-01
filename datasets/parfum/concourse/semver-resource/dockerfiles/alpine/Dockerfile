ARG base_image=alpine:latest
ARG builder_image=concourse/golang-builder

FROM ${builder_image} as builder
COPY . /src
WORKDIR /src
ENV CGO_ENABLED 0
RUN go get -d ./...
RUN go build -o /assets/in ./in
RUN go build -o /assets/out ./out
RUN go build -o /assets/check ./check
RUN set -e; for pkg in $(go list ./...); do \
		go test -o "/tests/$(basename $pkg).test" -c $pkg; \
	done

FROM ${base_image} AS resource
RUN apk update && apk upgrade
RUN apk add --no-cache bash tzdata ca-certificates git jq openssh
RUN git config --global user.email "git@localhost"
RUN git config --global user.name "git"
COPY --from=builder assets/ /opt/resource/
RUN chmod +x /opt/resource/*

FROM resource AS tests
ARG SEMVER_TESTING_ACCESS_KEY_ID
ARG SEMVER_TESTING_SECRET_ACCESS_KEY
ARG SEMVER_TESTING_BUCKET
ARG SEMVER_TESTING_REGION
ARG SEMVER_TESTING_V2_SIGNING
COPY --from=builder /tests /go-tests
WORKDIR /go-tests
RUN set -e; for test in /go-tests/*.test; do \
		$test; \
	done
COPY test/ /opt/resource-tests
RUN /opt/resource-tests/all.sh


FROM resource
