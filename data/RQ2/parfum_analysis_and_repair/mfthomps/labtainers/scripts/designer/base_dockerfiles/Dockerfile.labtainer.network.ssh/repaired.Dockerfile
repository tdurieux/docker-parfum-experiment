ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for networking Parameterized labs"
ARG lab
COPY system/etc/services /etc/services
COPY system/etc/xinetd.d/ssh /etc/xinetd.d/ssh