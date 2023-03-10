FROM alpine:3.2

# Reminder: Alpine compatible tarball not available on nodejs.org,
# and hence this image not included in for-each-container

# Alpine has wget by default, and not curl, but not compatible with n or nvh.
# alpine 3.2: wget -s
# alpine latest: wget --spider
#
# NB: downloaded Linux Binaries for node require glic and do not run!

RUN apk add --no-cache bash tar openssl ca-certificates curl

CMD ["/bin/bash"]