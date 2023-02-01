#
# To use it, build your image:
# docker build -t glouton .
# docker run --name="glouton" --net=host --pid=host -v /var/lib/glouton:/var/lib/glouton -v /var/run/docker.sock:/var/run/docker.sock -v /:/hostroot:ro glouton
#

FROM --platform=$BUILDPLATFORM busybox:1.34 as build

ARG TARGETARCH

COPY dist/glouton_linux_amd64_v1/glouton /glouton.amd64
COPY dist/glouton_linux_arm64/glouton /glouton.arm64
COPY dist/glouton_linux_arm_6/glouton /glouton.arm

RUN cp -p /glouton.$TARGETARCH /glouton

# We use busybox because we need nsenter and ip commands.