# SEE: Dockerfile

# SYNC: Dockerfile/1 {
FROM ruby:2.2.3
RUN \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        build-essential \
        libpq-dev && \
    useradd --home-dir /srv/tunefl/ --shell /usr/sbin/nologin tunefl && rm -rf /var/lib/apt/lists/*;
# SYNC: }

# The `lilypond` package has lots of dependencies, and installation takes a long
# time. This fragment should be placed at as low a layer as possible, but
# maximising the shared layers between `web` (`Dockerfile`) and `worker`
# (`Dockerfile.worker`). `web` does not need `lilypond`, so we keep that image
# clean.
RUN \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        lilypond && rm -rf /var/lib/apt/lists/*;

# SYNC: Dockerfile/2 {
WORKDIR /srv/tunefl/
USER tunefl
ENV BUNDLE_APP_CONFIG /srv/tunefl.bundle/
# SYNC: }
