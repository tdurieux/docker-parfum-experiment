FROM debian:stretch
ARG BUNDLE_DIR
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
# Use the BUNDLE_DIR build argument to copy files into the bundle
COPY . $BUNDLE_DIR
RUN apt-get update && \
 apt-get install --no-install-recommends -y apt-transport-https curl && \
 curl -f -o kubectl https://storage.googleapis.com/kubernetes-release/release/v1.15.5/bin/linux/amd64/kubectl && \
mv kubectl /usr/local/bin && \
chmod a+x /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;

# exec mixin has no buildtime dependencies

RUN rm -fr $BUNDLE_DIR/.cnab
COPY .cnab /cnab
COPY porter.yaml $BUNDLE_DIR/porter.yaml
WORKDIR $BUNDLE_DIR
CMD ["/cnab/app/run"]