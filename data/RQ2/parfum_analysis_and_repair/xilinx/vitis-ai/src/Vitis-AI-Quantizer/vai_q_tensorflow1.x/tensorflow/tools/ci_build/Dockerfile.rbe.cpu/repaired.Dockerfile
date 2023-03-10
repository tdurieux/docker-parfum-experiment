# To push a new version, run:
# $ docker build -f Dockerfile.rbe.cpu \
#       --tag "gcr.io/tensorflow-testing/nosla-ubuntu16.04" .
# $ docker push gcr.io/tensorflow-testing/nosla-ubuntu16.04

FROM launcher.gcr.io/google/rbe-ubuntu16-04:r327695
LABEL maintainer="Yu Yi <yiyu@google.com>"

# Copy install scripts
COPY install/*.sh /install/

# Setup envvars
ENV CC /usr/local/bin/clang
ENV CXX /usr/local/bin/clang++
ENV AR /usr/bin/ar

# Run pip install script for RBE Ubuntu 16-04 container.