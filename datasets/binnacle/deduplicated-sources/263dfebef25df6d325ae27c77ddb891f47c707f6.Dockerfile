#
# This is the default deployment strategy image for OpenShift Origin. It expects a set of
# environment variables to parameterize the deploy:
#
#   KUBERNETES_MASTER - the address of the OpenShift master
#   KUBERNETES_DEPLOYMENT_ID - the deployment identifier that is running this build
#
# The standard name for this image is openshift/origin-deployer
#
FROM openshift/origin

ENTRYPOINT ["/usr/bin/openshift-deploy"]
