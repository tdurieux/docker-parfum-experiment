# To build a docker image for bookstore
# you need to be running this on Linux.
#
# Here are the steps:
#
# 1) bazel build //test/transcoding:bookstore-server
# 2) cp bazel-bin/test/transcoding/bookstore-server test/transcoding
# 3) IMAGE=gcr.io/endpointsv2/bookstore-grpc:latest
# 4) docker build --no-cache -t "${IMAGE}" test/transcoding
# 5) gcloud docker -- push "${IMAGE}"