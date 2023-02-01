# Container for TKM testing
#
# Build and usage (called from repository root):
#
#   docker build -t strongswan-tkm -f testing/tkm/Dockerfile testing
#
#   docker run -it --rm --cap-add net_admin -v $PWD:/strongswan strongswan-tkm
#
# In the container, this may be used to configure strongSwan with TKM support:
#
#   /strongswan/configure --disable-defaults --enable-silent-rules --enable-ikev2 --enable-kernel-netlink --enable-openssl --enable-pem --enable-socket-default --enable-swanctl --enable-tkm
#
# The following script can be used to generate private key, CA cert and example
# config for TKM:
#
#   /usr/local/share/tkm/generate-config.sh
#
# Run TKM in the background with:
#
#   tkm_keymanager -c tkm.conf -k key.der -r ca.der:1 >/tmp/tkm.log &
#
# Then tests for charon-tkm can be run against TKM:
#
#   make -j check TESTS_RUNNERS=tkm TESTS_TKM=1