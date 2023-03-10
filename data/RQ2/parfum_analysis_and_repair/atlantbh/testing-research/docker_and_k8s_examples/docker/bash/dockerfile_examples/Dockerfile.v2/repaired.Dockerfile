# Example overview:
# - improvement on Dockerfile.v1 where ordering of commands is fixed to speed up building of docker image by paying attention to the layers
# - order should be from the commands that will change least to the commands that will change the most (installation of system libs goes first)
# - using alpine distro instead of ubuntu to shrink the size of the image
FROM alpine:3.12.0

# Install system deps
RUN apk update \
    && apk add --no-cache jq curl busybox-extras

# Do setup for running script
WORKDIR /myscripts
COPY ./example_1.sh .
RUN chmod +x example_1.sh

# Run script
ENTRYPOINT ["./example_1.sh", "-n", "Test"]