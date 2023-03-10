# Based on https://github.com/kubernetes/dashboard/blob/v2.5.1/aio/Dockerfile
ARG BASE_ALPINE
FROM kubernetesui/dashboard:v2.5.1@sha256:6614c53fcdb9df9cb920c701c6a418e398be9b5ee147e5231ad6669fd2b76862 as artifact

FROM $BASE_ALPINE

COPY --from=artifact /etc/passwd /etc/passwd
COPY --from=artifact /public /public
COPY --from=artifact /locale_conf.json /locale_conf.json
COPY --from=artifact /dashboard /dashboard

# Inject logout button to be able to change user if token authentication is used