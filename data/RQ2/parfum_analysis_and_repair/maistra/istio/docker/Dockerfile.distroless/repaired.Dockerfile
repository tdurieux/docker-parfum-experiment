# prepare a distroless source context to copy files from
FROM gcr.io/distroless/static-debian11@sha256:d6fa9db9548b5772860fecddb11d84f9ebd7e0321c0cb3c02870402680cc315f as distroless_source

# prepare a base dev to modify file contents
FROM ubuntu:focal as ubuntu_source

# Modify contents of container
COPY --from=distroless_source /etc/ /home/etc
COPY --from=distroless_source /home/nonroot /home/nonroot
RUN echo istio-proxy:x:1337: >> /home/etc/group
RUN echo istio-proxy:x:1337:1337:istio-proxy:/nonexistent:/sbin/nologin >> /home/etc/passwd

# Customize distroless with the following:
# - password file
# - groups file
# - /home/nonroot directory