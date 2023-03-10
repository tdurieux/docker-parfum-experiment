FROM --platform=$BUILDPLATFORM debian:stable-slim

ARG TARGETARCH

WORKDIR /jackal

LABEL org.label-schema.vcs-url="https://github.com/ortuman/jackal.git"
LABEL org.label-schema.name="jackal"
LABEL org.label-schema.vendor="Miguel Ángel Ortuño"
LABEL maintainer="Miguel Ángel Ortuño <ortuman@protonmail.com>"

ADD build/$TARGETARCH/jackal /jackal
ADD build/$TARGETARCH/jackalctl /jackal

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

EXPOSE 5222

ENV PATH $PATH:/jackal

CMD ["./jackal"]
