ARG TARGETPLATFORM="linux/amd64"
ARG REF_NAME="v0.0.5"
# ARG FFMPEG_IMAGE="mwader/static-ffmpeg:5.0.1-3"
# ARG FFMPEG_SRC_PATH="/ffmpeg"
# ARG FFMPEG_DST_PATH="/usr/local/bin/"

# FROM ${FFMPEG_IMAGE} as ffmpeg_image

FROM alpine:3.16.0
ARG TARGETPLATFORM
ARG REF_NAME
ENV WORKDIR /mnt/

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  apk add --no-cache --update --upgrade libstdc++ wget && \
  if [ "$TARGETPLATFORM" = "linux/arm/v6" ]; then \
    SUFFIX=linux-arm ; \
  elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
    SUFFIX=linux-arm ; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    SUFFIX=linux-arm64 ; \    
  elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    SUFFIX=linux-musl-x64 ; \
  fi && \
  TONE_VERSION=$(echo "$REF_NAME" | sed 's/^v//g') && \
  wget "https://github.com/sandreas/tone/releases/download/v$TONE_VERSION/tone-$TONE_VERSION-$SUFFIX.tar.gz" \
    -O /tmp/tone.tar.gz && \
    cd /tmp/ && tar xzf tone.tar.gz && mv tone-$TONE_VERSION-$SUFFIX/tone /usr/local/bin/ && rm tone.tar.gz

# COPY --from=ffmpeg_image "$FFMPEG_SRC_PATH" "$FFMPEG_DST_PATH"

WORKDIR ${WORKDIR}
CMD ["--version"]
ENTRYPOINT ["/usr/local/bin/tone"]