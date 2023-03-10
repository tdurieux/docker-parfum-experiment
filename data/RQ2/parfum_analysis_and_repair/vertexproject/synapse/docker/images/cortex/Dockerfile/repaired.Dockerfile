# vim:set ft=dockerfile:
FROM vertexproject/vtx-base-image:py38

COPY synapse /build/synapse/synapse
COPY setup.py /build/synapse/setup.py
COPY MANIFEST.in /build/synapse/MANIFEST.in

COPY docker/bootstrap.sh /build/synapse/bootstrap.sh
COPY docker/images/cortex/entrypoint.sh /vertex/synapse/entrypoint.sh

RUN /build/synapse/bootstrap.sh

EXPOSE 4443
EXPOSE 27492

VOLUME /vertex/storage

ENTRYPOINT ["tini", "--", "/vertex/synapse/entrypoint.sh"]

HEALTHCHECK --start-period=10s --retries=1 --timeout=10s --interval=30s CMD python -m synapse.tools.healthcheck -c cell:///vertex/storage/