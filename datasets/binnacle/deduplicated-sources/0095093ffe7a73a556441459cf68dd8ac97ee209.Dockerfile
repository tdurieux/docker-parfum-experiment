FROM registry.access.redhat.com/ubi8/ubi-minimal:latest 

ADD tmp/_output/bin/istio-operator /usr/local/bin/istio-operator
COPY tmp/_output/helm/istio-releases/istio-1.1.0 /etc/istio-operator/1.1.0/helm
