ARG GOLANG_IMAGE
FROM ${GOLANG_IMAGE} AS common

ENV CGO_ENABLED 0
ENV GO111MODULES on

WORKDIR /conform
COPY go.mod ./
COPY go.sum ./
RUN go mod download
RUN go mod verify
COPY ./ ./
RUN go list -mod=readonly all

FROM common AS build
ARG TAG
ARG SHA
ARG BUILT
ENV GOOS linux
ENV GOARCH amd64
RUN go build -o /conform-${GOOS}-${GOARCH} -ldflags "-s -w -X \"github.com/autonomy/conform/cmd.Tag=${TAG}\" -X \"github.com/autonomy/conform/cmd.SHA=${SHA}\" -X \"github.com/autonomy/conform/cmd.Built=${BUILT}\"" .

ARG TAG
ARG SHA
ARG BUILT
ENV GOOS darwin
ENV GOARCH amd64
RUN go build -o /conform-${GOOS}-${GOARCH} -ldflags "-s -w -X \"github.com/autonomy/conform/cmd.Tag=${TAG}\" -X \"github.com/autonomy/conform/cmd.SHA=${SHA}\" -X \"github.com/autonomy/conform/cmd.Built=${BUILT}\"" .

FROM common AS test
ENV GOOS linux
ENV GOARCH amd64
COPY ./hack ./hack
RUN chmod +x ./hack/test.sh
RUN ./hack/test.sh --all

FROM scratch AS image
COPY --from=build /conform-linux-amd64 /conform
ENTRYPOINT [ "/conform" ]
CMD [ "enforce" ]
