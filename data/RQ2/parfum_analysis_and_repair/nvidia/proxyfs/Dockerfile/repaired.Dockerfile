# Copyright (c) 2015-2022, NVIDIA CORPORATION.
# SPDX-License-Identifier: Apache-2.0

# To build this image:
#
#   docker build                                      \
#          --target {base|dev|build|deploy}           \
#          [--build-arg GolangVersion=<X.YY.Z>]       \
#          [--build-arg MakeTarget={|all|ci|minimal}] \
#          [-t <repository>[:<tag>]]                  .
#
#   Notes:
#     --target base:
#       1) provides a clean/small base image for the rest to leverage
#       2) only addition is libc6-compat to enable Golang runtime compatibility
#     --target dev:
#       1) builds an image capable of building all elements
#       2) /src is shared with context dir of host
#     --target build:
#       1) clones the context dir at /clone
#       2) performs a make clean to clear out non-source-controlled artifacts
#       3) performs a make $MakeTarget
#     --target deploy:
#       1) provides a minimal image containing ickpt, imgr, and iclient
#       2) also includes the icert tool useful for the following steps
#       3) creates TLS cert/key files for RootCA
#       4) creates TLS cert/key files for ickpt
#       5) creates TLS cert/key files for imgr
#     --build-arg GolangVersion:
#       1) identifies Golang version
#       2) default specified in ARG GolangVersion line in --target base
#     --build-arg MakeTarget:
#       1) identifies Makefile target(s) to build (following make clean)
#       2) defaults to blank (equivalent to "minimal")
#       3) only used in --target build
#     -t:
#       1) provides a name REPOSITORY:TAG for the built image
#       2) if no tag is specified, TAG will be "latest"
#       3) if no repository is specified, only the IMAGE ID will identify the built image
#
# To run the resultant image:
#
#   docker run                                                        \
#          [-d|--detach]                                              \
#          [-it]                                                      \
#          [--rm]                                                     \
#          [--privileged]                                             \
#          [--mount src="$(pwd)",target="/src",type=bind]             \
#          [--env DISPLAY=<hostOrIP>:<displayNumber>[.<screenNumber]] \
#          <image id>|<repository>[:<tag>]
#
#   Notes:
#     -d|--detach:   tells Docker to detach from running container 
#     -it:           tells Docker to run container interactively
#     --rm:          tells Docker to destroy container upon exit
#     --privileged:
#       1) tells Docker to, among other things, grant access to /dev/fuse
#       2) only useful for --target dev and --target iclient
#     --mount:
#       1) bind mounts the context into /src in the container
#       2) /src will be a read-write'able equivalent to the context dir
#       3) only useful for --target dev
#     --env DISPLAY: tells Docker to set ENV DISPLAY for X apps (e.g. wireshark)