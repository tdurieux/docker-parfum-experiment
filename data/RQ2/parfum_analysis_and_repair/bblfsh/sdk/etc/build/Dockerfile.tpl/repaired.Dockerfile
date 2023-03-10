# This file can be used directly with Docker.
#
# Prerequisites:
#   go mod vendor
#   bblfsh-sdk release
#
# However, the preferred way is:
#   go run ./build.go driver:tag
#
# This will regenerate all necessary files before building the driver.

#==============================
# Stage 1: Native Driver Build
#==============================
{{if and (ne .Native.Build.Gopath "") (eq .Native.Build.Image "") -}}
FROM golang:{{ .Runtime.Version }} as native
{{- else -}}
FROM {{ .Native.Build.Image }} as native
{{- end}}

{{- if ne (len .Native.Build.BuildAssets) 0}}

# add dependency files
{{range .Native.Build.BuildAssets -}}
ADD {{ .Path }} {{ .Dest }}
{{end}}
{{- end}}

{{- if ne (len .Native.Build.Deps) 0}}

# install build dependencies
{{range .Native.Build.Deps -}}
RUN {{ . }}
{{end}}
{{- end}}

{{if ne .Native.Build.Gopath "" -}}
ENV DRIVER_REPO=github.com/bblfsh/{{ .Language }}-driver
ENV DRIVER_REPO_PATH={{ .Native.Build.Gopath }}/src/$DRIVER_REPO

ADD go.* $DRIVER_REPO_PATH/
ADD vendor $DRIVER_REPO_PATH/vendor
ADD driver $DRIVER_REPO_PATH/driver
ADD native $DRIVER_REPO_PATH/native
WORKDIR $DRIVER_REPO_PATH/native
ENV GO111MODULE=on GOFLAGS=-mod=vendor
{{- else -}}
ADD native /native
WORKDIR /native
{{- end}}

# build native driver
{{range .Native.Build.Build -}}
RUN {{ . }}
{{end}}

#================================
# Stage 1.1: Native Driver Tests
#================================
FROM native as native_test
{{if ne .Native.Build.Gopath ""}}
# workaround for https://github.com/golang/go/issues/28065
ENV CGO_ENABLED=0
{{end -}}

{{- if ne (len .Native.Test.Deps) 0}}
# install test dependencies
{{range .Native.Test.Deps -}}
RUN {{ . }}
{{end}}
{{- end}}
# run native driver tests
{{range .Native.Test.Test -}}
RUN {{ . }}
{{end}}

#=================================
# Stage 2: Go Driver Server Build
#=================================
{{if ne .Native.Build.Gopath "" -}}
FROM native as driver
{{- else -}}
FROM golang:{{ .Runtime.Version }} as driver

ENV DRIVER_REPO=github.com/bblfsh/{{ .Language }}-driver
ENV DRIVER_REPO_PATH=/go/src/$DRIVER_REPO

ADD go.* $DRIVER_REPO_PATH/
ADD vendor $DRIVER_REPO_PATH/vendor
ADD driver $DRIVER_REPO_PATH/driver
{{- end}}

WORKDIR $DRIVER_REPO_PATH/

ENV GO111MODULE=on GOFLAGS=-mod=vendor

# workaround for https://github.com/golang/go/issues/28065
ENV CGO_ENABLED=0

# build server binary
RUN go build -o /tmp/driver ./driver/main.go
# build tests
RUN go test -c -o /tmp/fixtures.test ./driver/fixtures/

#=======================
# Stage 3: Driver Build
#=======================
FROM {{ .Native.Image }}

{{range .Native.Deps -}}
RUN {{ . }}
{{end}}

LABEL maintainer="source{d}" \
      bblfsh.language="{{ .Language }}"

WORKDIR /opt/driver

{{- if ne (len .Native.ImageAssets) 0}}

# copy static files from driver source directory
{{range .Native.ImageAssets -}}
ADD ./native/{{ .Path }} ./bin/{{ .Dest }}
{{end}}
{{- end}}

# copy build artifacts for native driver
{{range .Native.Build.Artifacts -}}
COPY --from=native {{ .Path }} ./bin/{{ .Dest }}
{{end}}

# copy driver server binary
COPY --from=driver /tmp/driver ./bin/

# copy tests binary
COPY --from=driver /tmp/fixtures.test ./bin/
# move stuff to make tests work
RUN ln -s /opt/driver ../build
VOLUME /opt/fixtures

# copy driver manifest and static files