FROM registry.ci.openshift.org/openshift/release:golang-1.18

# setting Git username and email for workaround of
# https://github.com/jenkinsci/docker/issues/519
ENV GIT_COMMITTER_NAME hive-team
ENV GIT_COMMITTER_EMAIL hive-team@redhat.com

# Basic Debug Tools
RUN yum -y install strace tcping && yum clean all && rm -rf /var/cache/yum

# Get rid of "go: disabling cache ..." errors.
RUN mkdir -p /go && chgrp -R root /go && chmod -R g+rwX /go
