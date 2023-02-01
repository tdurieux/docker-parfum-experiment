#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent:jdk8
MAINTAINER 若虚 <slpcat@qq.com>

USER root

RUN \
    apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
