FROM registry.access.redhat.com/ubi8/nodejs-12

USER root

RUN wget https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod 755 /usr/local/bin/yq

RUN wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -O /usr/local/bin/stern && \
    chmod 755 /usr/local/bin/stern

# DOCKER_BUILDKIT=1 docker build --progress=plain --secret id=myuser,src=../docker-secrets/myuser.txt --secret id=mypass,src=../docker-secrets/mypass.txt -f Dockerfile-tekton-tutorial-base -t quay.io/mhildenb/tekton-tutorial-base:1.0 .
RUN --mount=type=secret,id=myuser --mount=type=secret,id=mypass \
    subscription-manager register  --username=$(cat /run/secrets/myuser) \
    --password=$(cat /run/secrets/mypass) --auto-attach

# RUN yum install -y yum-utils

RUN yum install -y python36 && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir httpie

RUN subscription-manager unregister

RUN curl -f -L https://github.com/tektoncd/cli/releases/download/v0.12.1/tkn_0.12.1_Linux_x86_64.tar.gz | \
    tar -xvzf - -C /usr/local/bin/ tkn && chmod 755 /usr/local/bin/tkn && \
    wget -qO- https://mirror.openshift.com/pub/openshift-v4/clients/serverless/0.16.1/kn-linux-amd64-0.16.1.tar.gz | tar -zxvf - -C /usr/local/bin ./kn && chmod 755 /usr/local/bin/kn

RUN curl -f -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
    tar -xvzf - -C /usr/local/bin/ oc && chmod 755 /usr/local/bin/oc && ln -s /usr/local/bin/oc /usr/local/bin/kubectl

USER default
