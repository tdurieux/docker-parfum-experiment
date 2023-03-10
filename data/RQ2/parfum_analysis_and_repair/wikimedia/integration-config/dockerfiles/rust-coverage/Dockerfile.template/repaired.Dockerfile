FROM {{ "rust" | image_tag }}

USER root

RUN {{ "xsltproc" | apt_install }}

COPY run.sh /run.sh
COPY cobertura-clover-transform.xslt /usr/bin/cobertura-clover-transform.xslt

USER nobody

RUN cargo install cargo-tarpaulin

ENTRYPOINT ["/run.sh"]