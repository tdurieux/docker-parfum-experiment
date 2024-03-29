FROM quay.io/centos7/postgresql-12-centos7:latest

COPY --from=quay.io/goswagger/swagger:v0.28.0 /usr/bin/swagger /usr/bin/goswagger
COPY --from=quay.io/edge-infrastructure/swagger-codegen-cli:2.4.18 /opt/swagger-codegen-cli /opt/swagger-codegen-cli
COPY --from=quay.io/app-sre/golangci-lint:v1.37.1 /usr/bin/golangci-lint /usr/bin/golangci-lint

ENV GOPATH=/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

USER 0

RUN mkdir build && chmod g+xw -R build/

RUN yum install -y --setopt=skip_missing_names_on_install=False \
        gcc genisoimage git libvirt-client libvirt-devel java && yum clean all && rm -rf /var/cache/yum

COPY --from=registry.ci.openshift.org/openshift/release:golang-1.17 /usr/bin/gotestsum /usr/bin/make /usr/bin/
COPY --from=registry.ci.openshift.org/openshift/release:golang-1.17 /usr/local/go /usr/local/go

COPY ./hack/setup_env.sh ./dev-requirements.txt ./
RUN ./setup_env.sh assisted_service

RUN chmod g+xw -R $GOPATH && chmod g+xw -R $(go env GOROOT)

COPY --from=quay.io/openshift/origin-cli:latest /usr/bin/oc /usr/bin
COPY --from=quay.io/operator-framework/upstream-opm-builder:v1.16.1 /bin/opm /bin
COPY ./data /tmp/data
COPY . .

RUN chmod g+xw -R .
