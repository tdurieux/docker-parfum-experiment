FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.3.5

MAINTAINER "Yousong Zhou <zhouyousong@yunionyun.com>"

ENV TZ UTC

# openssh-client, for ansible ssh connection
# git, ca-certificates, for fetching ansible roles
RUN set -x \
	&& apk update \
	&& apk add openssh-client \
	&& apk add sshpass \
	&& apk add ansible \
    && apk add py3-pip \
	&& apk add tzdata git ca-certificates \
	&& rm -rf /var/cache/apk/*

RUN pip3 install --no-cache-dir pywinrm
