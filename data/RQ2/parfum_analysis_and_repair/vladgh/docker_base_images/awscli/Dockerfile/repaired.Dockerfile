FROM alpine:3
LABEL maintainer "Vlad Ghinea vlad@ghn.me"

# Environment
ENV AWS_DEFAULT_REGION=us-east-1

# Install packages
RUN apk --no-cache add bash findutils git groff less python3 tini

# Install pip packages
RUN apk --no-cache add --virtual build-dependencies py-pip && \
    pip --no-cache-dir install awscli && \
    apk del build-dependencies

# Entrypoint
ENTRYPOINT ["/sbin/tini", "--", "aws"]
CMD ["--version"]

# Metadata params
ARG VERSION
ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.opencontainers.image.title="VGH AWS CLI" \
      org.opencontainers.image.url="$VCS_URL" \
      org.opencontainers.image.authors="Vlad Ghinea" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.source="$VCS_URL" \
      org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.created="$BUILD_DATE"