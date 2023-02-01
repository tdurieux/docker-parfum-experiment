#
# This image is for the master of an openshift dind dev cluster.
#
# The standard name for this image is openshift/dind-master
#

FROM openshift/dind-node

# Disable iptables on the master since it will prevent access to the
# openshift api from outside the master.