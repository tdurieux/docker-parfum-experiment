# Dockerfile for building and running ICU tests.
#
# Intended directory layout:
#
# /usr/local    - installed libraries
# /src/icu      - ICU library checkout
# /src/rust_icu - rust_icu library checkout, source
#
# Build with:
#   docker build test .
# Run with:
#   docker run test