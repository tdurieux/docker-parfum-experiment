# Create a builder container
# golang:1.16.0-buster amd64
FROM golang@sha256:f254180c5defa2653955e963fb0626e3d4fbbb162f7cff6490e94607d1d867ff AS build
WORKDIR /go/src/app

# Create appuser to isolate potential vulnerabilities
# See https://stackoverflow.com/a/55757473/12429735
ENV USER=appuser
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

# Create a new tmp directory so no bad actors can manipulate it
RUN mkdir /temporary-tmp-directory && chmod 777 /temporary-tmp-directory

###############################################################################
# Final stage
FROM scratch

# Allow container to use latest TLS certificates
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy over appuser to run as non-root
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

# Copy over the /tmp directory for golang/os.TmpDir
COPY --chown=appuser --from=build /temporary-tmp-directory /tmp

# Copy application from external build
COPY govc /govc

# Run all commands as non-root
USER appuser:appuser

# session cache, etc
ENV GOVMOMI_HOME=/tmp

# Set CMD to application with container defaults