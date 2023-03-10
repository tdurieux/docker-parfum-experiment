# This Dockerfile is for building an image suitable for running tango's GPU tests and integration tests.
# There are no instruction lines in this Dockerfile that install tango. Instead, the entrypoint
# script handles installing tango from a particular commit at runtime, based on the environment
# variable "COMMIT_SHA". That way we don't need to rebuild and push the image each time we run
# tests, and we can be sure the dependencies are always up-to-date.