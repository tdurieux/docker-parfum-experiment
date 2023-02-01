# Install the built rpms and test them
FROM dist-base as dist
# If you want to install extra packages or do generic configuration,
# do it before the COPY. Either here, or in the dist-base layer.

COPY --from=sdist /sdist /sdist
COPY --from=package-builder /dist /dist

# Install built packages with dependencies
RUN yum localinstall -y /dist/*/*.rpm

# Installation tests