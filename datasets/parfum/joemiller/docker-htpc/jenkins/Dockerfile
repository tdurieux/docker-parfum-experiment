FROM docker:stable as docker

FROM jenkins/jenkins:lts

COPY --from=docker /usr/local/bin/docker /bin/docker
