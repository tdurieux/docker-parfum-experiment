FROM caicloud/cyclone-base-alpine:v1.1.0-arm64v8

LABEL maintainer="zhujian@caicloud.io"

WORKDIR /workspace

COPY ./bin/workflow/controller /workspace/controller

CMD ["./controller"]