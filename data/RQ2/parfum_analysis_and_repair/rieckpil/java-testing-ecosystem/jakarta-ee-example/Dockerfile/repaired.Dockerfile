FROM openliberty/open-liberty:21.0.0.9-kernel-slim-java11-openj9-ubi

COPY --chown=1001:0  src/main/liberty/config /config/

# This script will add the requested XML snippets to enable Liberty features and grow image to be fit-for-purpose using featureUtility.
# Only available in 'kernel-slim'.
RUN features.sh

COPY --chown=1001:0  target/jakarta-ee-example.war /config/dropins/

# This script will add the requested server configurations, apply any interim fixes and populate caches to optimize runtime.
RUN configure.sh