# This file builds the metadata backend server image at
# gcr.io/kubeflow-images-public/metadata.
#
# The docker build flags are
# BASE_IMG: base image that has Go and Bazel installed.
# EXTRA_BAZEL_ARGS: extra arguments of bazel build. Set it to
# --host_javabase=@local_jdk//:jdk when build on power or arm64 machines.
# OUTPUT_DIR: the platform name that Bazel used to ouput the executable.