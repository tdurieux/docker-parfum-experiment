FROM busybox:latest@sha256:b26cd013274a657b86e706210ddd5cc1f82f50155791199d29b9e86e935ce135
RUN ["/bin/ln", "-s", "nowhere", "/link"]