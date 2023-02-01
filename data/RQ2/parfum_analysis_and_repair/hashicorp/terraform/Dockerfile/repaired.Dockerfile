# This Dockerfile builds on golang:alpine by building Terraform from source
# using the current working directory.
#
# This produces a docker image that contains a working Terraform binary along
# with all of its source code. This is not what produces the official releases
# in the "terraform" namespace on Dockerhub; those images include only
# the officially-released binary from releases.hashicorp.com and are
# built by the (closed-source) official release process.