FROM scratch
MAINTAINER nobody@domain.test
# Add a file to the image to work around https://github.com/moby/moby/issues/38039
COPY context/foo /foo