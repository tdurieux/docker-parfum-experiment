# need helm CLI for final image
FROM registry.ci.openshift.org/ocp/4.8:metering-helm as helm
# image needs kubectl, so we copy `oc` from cli image to use as kubectl.
FROM registry.ci.openshift.org/ocp/4.8:cli as cli
# need golang for the unit/vendor/verify CI checks
FROM registry.ci.openshift.org/ocp/builder:golang-1.15

# go get faq via static Linux binary approach
ARG LATEST_RELEASE=0.0.6
RUN curl -f -Lo /usr/local/bin/faq https://github.com/jzelinskie/faq/releases/download/$LATEST_RELEASE/faq-linux-amd64
RUN chmod +x /usr/local/bin/faq

ARG OPM_RELEASE=v1.15.0
RUN curl -f -Lo /usr/local/bin/opm https://github.com/operator-framework/operator-registry/releases/download/$OPM_RELEASE/linux-amd64-opm
RUN chmod +x /usr/local/bin/opm

ARG OPERATOR_SDK_RELEASE=v1.2.0
RUN curl -f -Lo /usr/local/bin/operator-sdk https://github.com/operator-framework/operator-sdk/releases/download/$OPERATOR_SDK_RELEASE/operator-sdk-$OPERATOR_SDK_RELEASE-x86_64-linux-gnu
RUN chmod +x /usr/local/bin/operator-sdk

COPY --from=cli /usr/bin/oc /usr/bin/
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm

RUN ln -s /usr/bin/oc /usr/bin/kubectl
RUN go get -u github.com/jstemmer/go-junit-report

ENV GOCACHE='/tmp'

CMD ["/bin/bash"]
