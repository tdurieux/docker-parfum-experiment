# image-name: ghcr.io/dena/unity-meta-check/unity-meta-check-circleci
FROM golang:1.16-buster as builder
WORKDIR /go/src/unity-meta-check
COPY . .
RUN make out/unity-meta-check-linux-amd64 out/unity-meta-check-junit-linux-amd64 out/unity-meta-check-github-pr-comment-linux-amd64 out/unity-meta-autofix-linux-amd64 && \
	mv ./out/unity-meta-check-linux-amd64 ./out/unity-meta-check && \
	mv ./out/unity-meta-check-junit-linux-amd64 ./out/unity-meta-check-junit && \
	mv ./out/unity-meta-check-github-pr-comment-linux-amd64 ./out/unity-meta-check-github-pr-comment && \
	mv ./out/unity-meta-autofix-linux-amd64 ./out/unity-meta-autofix

FROM debian:buster-slim
# https://circleci.com/docs/2.0/custom-images/#required-tools-for-primary-containers