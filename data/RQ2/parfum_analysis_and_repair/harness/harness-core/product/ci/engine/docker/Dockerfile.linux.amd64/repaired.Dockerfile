# Create image for ci-lite-engine which will orchestrate steps in a stage
#
# Build the ci-engine docker image using:
# > bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //product/ci/engine:engine
# > docker build -t harness/ci-lite-engine:<tag> -f product/ci/engine/Dockerfile $(bazel info bazel-bin)/product/ci/engine/