ARG REPO=forgerock-docker-public.bintray.io/forgerock/openig
#ARG TAG=6.5.0-RC2
ARG TAG=latest
FROM $REPO:$TAG
#FROM forgerock-docker-public.bintray.io/forgerock/openig:6.5.0-RC2

COPY --chown=forgerock config/ /git/config

# IG wants to create files under /git/{logs,scripts}
USER root
RUN chown -R forgerock:forgerock /git 
USER forgerock

