# Note to self: Alpine Linux is the devil and should not be used
FROM alpine:latest
# copy the vsock-sample binary
COPY runtime_manager_enclave .
# start the server inside the enclave