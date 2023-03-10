FROM alpine as munger

ARG new_image_name
COPY upstream-manifests manifests
RUN sed "s,quay.io/kubernetes-multicluster/federation-v2:v0.0.10,$new_image_name," -i manifests/federation/0.0.10/federation.v0.0.10.clusterserviceversion.yaml
RUN sed "s,IfNotPresent,Always," -i manifests/federation/0.0.10/federation.v0.0.10.clusterserviceversion.yaml
RUN sed "s,quay.io/kubernetes-multicluster/federation-v2:v0.0.10,$new_image_name," -i manifests/cluster-federation/0.0.10/cluster-federation.v0.0.10.clusterserviceversion.yaml
RUN sed "s,IfNotPresent,Always," -i manifests/cluster-federation/0.0.10/cluster-federation.v0.0.10.clusterserviceversion.yaml

FROM quay.io/openshift/origin-operator-registry:latest

COPY --from=munger manifests manifests
RUN initializer

CMD ["registry-server"]