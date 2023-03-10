FROM registry.ci.openshift.org/openshift/release:golang-1.17 as build

ENV GO111MODULE=on
ENV GOFLAGS=""

RUN yum install -y python3-pip && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -f --retry 5 -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | \
    bash -s -- 3.8.8 && mv kustomize /usr/bin/
RUN pip3 install --no-cache-dir waiting==1.4.1
COPY --from=quay.io/openshift/origin-cli:latest /usr/bin/oc /usr/bin
RUN go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.4.0
RUN export ARCH=$(case $(arch) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(arch) ;; esac) \
  && export OS=$(uname | awk '{print tolower($0)}') && export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.7.2 \
  && curl -f --retry 5 -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH} \
  && chmod +x operator-sdk_${OS}_${ARCH} \
  && install operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk

COPY . .
RUN export BUNDLE_OUTPUT_DIR=/bundle; make operator-bundle

FROM scratch

LABEL operators.operatorframework.io.bundle.mediatype.v1=registry+v1
LABEL operators.operatorframework.io.bundle.manifests.v1=manifests/
LABEL operators.operatorframework.io.bundle.metadata.v1=metadata/
LABEL operators.operatorframework.io.bundle.package.v1=assisted-service-operator
LABEL operators.operatorframework.io.bundle.channels.v1=alpha
LABEL operators.operatorframework.io.metrics.builder=operator-sdk-v1.4.0
LABEL operators.operatorframework.io.metrics.mediatype.v1=metrics+v1
LABEL operators.operatorframework.io.metrics.project_layout=go.kubebuilder.io/v3
LABEL operators.operatorframework.io.test.config.v1=tests/scorecard/
LABEL operators.operatorframework.io.test.mediatype.v1=scorecard+v1
COPY --from=build /bundle/manifests /manifests/
COPY --from=build /bundle/metadata /metadata/
COPY --from=build /bundle/tests/scorecard /tests/scorecard/
