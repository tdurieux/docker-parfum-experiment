FROM quay.io/openshift/origin-operator-registry:latest

ARG version=0.1.0

COPY manifests manifests
COPY deploy/crds/*.yaml manifests/devconsole/${version}/

RUN sed -e "s,REPLACE_IMAGE,registry.svc.ci.openshift.org/${OPENSHIFT_BUILD_NAMESPACE}/stable:devconsole-operator," -i manifests/devconsole/${version}/devconsole-operator.v${version}.clusterserviceversion.yaml
RUN initializer

USER 1001
EXPOSE 50051
CMD ["registry-server", "--termination-log=log.txt"]
