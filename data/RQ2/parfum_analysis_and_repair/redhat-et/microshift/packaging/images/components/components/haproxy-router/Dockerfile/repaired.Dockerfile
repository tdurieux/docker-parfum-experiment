# https://github.com/openshift/router/blob/master/images/router/haproxy/Dockerfile.rhel8
FROM fedora-minimal:36
# ubi-8 images don't have haproxy22, so we rely on fedora-minimal:36 in this case