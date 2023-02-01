# Uses a multi-stage container build to build the RP.
#
# TODO:
# Currently the docker version on our RHEL7 VMSS uses a version which
# does not support multi-stage builds.  This is a temporary stop-gap
# until we get podman working without issue