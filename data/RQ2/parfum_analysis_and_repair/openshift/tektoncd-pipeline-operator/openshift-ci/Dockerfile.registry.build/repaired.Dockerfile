FROM quay.io/openshift/origin-operator-registry:latest

# ARG version=0.5.2

# COPY deploy/olm-catalog manifests

# RUN sed -e \
#   "s,REPLACE_IMAGE,registry.svc.ci.openshift.org/${OPENSHIFT_BUILD_NAMESPACE}/stable:tektoncd-pipeline-operator," \
#   -i manifests/openshift-pipelines-operator/${version}/openshift-pipelines-operator.v${version}.clusterserviceversion.yaml
# RUN initializer

USER 1001
EXPOSE 50051
CMD ["registry-server", "--termination-log=log.txt"]