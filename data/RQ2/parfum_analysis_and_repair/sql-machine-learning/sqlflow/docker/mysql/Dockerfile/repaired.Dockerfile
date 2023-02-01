# This Dockerfile contains MySQL server and example datasets to be
# populated into the server.  To COPY .sql dataset files outside of
# this directory into the image, we need to run docker build from the
# root directory of the SQLFlow source tree.
#
# To build this image:
#
#  cd $(git rev-parse --show-toplevel)
#  docker build -t sqlflow:mysql -f docker/mysql/Dockerfile .
#
# To start a container executing this image:
#
#  docker run --rm -d -P --name mysql_server -v $PWD:/notify sqlflow:mysql
#
# To start a client container that can access this image:
#
#  docker run --rm --net=container:mysql_server -v $PWD:/notify sqlflow:ci
#
# The bind mount of $PWD on the host to /notify allows the
# sqlflow:mysql container to create a file in the directory after
# populating datasets, and the container running sqlflow:ci can use
# inotifywait to wait for the creation of this file before it go on
# running tests.
FROM alpine:3.12

# Install sample datasets for CI and demo.