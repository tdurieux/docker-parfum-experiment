FROM quay.io/cilium/cilium-builder:b7d0138c0c9bd5ed791117d924e57e99fe078b63@sha256:448b7ba8e7ae1628419b5857b80ad5c3c931d32835ea637095b1503acd0e68f7
RUN --mount=type=bind,readwrite,target=/go/src/github.com/cilium/tetragon cd /go/src/github.com/cilium/tetragon && go install ./cmd/protoc-gen-go-tetragon

#- vi:ft=dockerfile -#