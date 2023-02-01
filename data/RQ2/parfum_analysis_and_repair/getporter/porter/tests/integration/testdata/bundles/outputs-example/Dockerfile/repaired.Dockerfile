FROM debian:stretch-slim

ARG BUNDLE_DIR

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

# exec mixin has no buildtime dependencies


COPY . ${BUNDLE_DIR}
RUN rm -fr ${BUNDLE_DIR}/.cnab
COPY .cnab /cnab
COPY porter.yaml ${BUNDLE_DIR}/porter.yaml
WORKDIR ${BUNDLE_DIR}
CMD ["/cnab/app/run"]