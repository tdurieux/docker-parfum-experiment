FROM {{ .from }}
RUN apk --no-cache add ca-certificates libc6-compat
COPY build/plugin/dockerlogbeat /usr/bin/