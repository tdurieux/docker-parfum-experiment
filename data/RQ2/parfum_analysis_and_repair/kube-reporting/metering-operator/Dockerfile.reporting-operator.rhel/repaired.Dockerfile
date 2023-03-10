FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.16-openshift-4.8 AS build

COPY . /go/src/github.com/kube-reporting/metering-operator
WORKDIR /go/src/github.com/kube-reporting/metering-operator

ENV GOCACHE='/tmp'
RUN make reporting-operator-bin RUN_UPDATE_CODEGEN=false CHECK_GO_FILES=false

FROM registry.ci.openshift.org/ocp/4.8:base

RUN yum install --setopt=skip_missing_names_on_install=False -y \
        ca-certificates bash && rm -rf /var/cache/yum

COPY --from=build /go/src/github.com/kube-reporting/metering-operator/bin/reporting-operator /usr/local/bin/reporting-operator

USER 3001
ENTRYPOINT ["reporting-operator"]
CMD ["start"]

LABEL io.k8s.display-name="OpenShift metering-reporting-operator" \
      io.k8s.description="This is a component of OpenShift Container Platform and manages collecting data from monitoring and running reports." \
      summary="This is a component of OpenShift Container Platform and manages collecting data from monitoring and running reports." \
      io.openshift.tags="openshift" \
      maintainer="<metering-team@redhat.com>"
