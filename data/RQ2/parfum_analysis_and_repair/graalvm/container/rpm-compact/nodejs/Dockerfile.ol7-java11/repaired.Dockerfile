# LICENSE UPL 1.0
#
# Copyright (c) 2021, 2022 Oracle and/or its affiliates. All rights reserved.
#

FROM container-registry.oracle.com/os/oraclelinux:7-slim

# Note: If you are behind a web proxy, set the build variables for the build:
#       E.g.:  docker build --build-arg 'https_proxy=...' --build-arg 'http_proxy=...' --build-arg 'no_proxy=...' ...