# Mini dockerfile to serve up narrative version until we can migrate this into
# the narrative method service

FROM nginx:stable-alpine

# These ARGs values are passed in via the docker build command
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop
ARG NARRATIVE_VERSION
ARG NARRATIVE_GIT_HASH

EXPOSE 80

RUN echo >/usr/share/nginx/html/narrative_version '{"version":"'${NARRATIVE_VERSION}'","git_hash":"'${NARRATIVE_GIT_HASH}'"}' && \
    cat /usr/share/nginx/html/narrative_version

# Replace index file with redirect to www.kbase.us