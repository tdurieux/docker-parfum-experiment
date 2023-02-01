FROM registry.cn-beijing.aliyuncs.com/yunionio/ansibleserver-base:v1.1.0

# install playbook and telegraf install pkg
COPY --from=registry.cn-beijing.aliyuncs.com/yunionio/file-repo:v0.4.0 /opt/yunion/playbook /opt/yunion/playbook
COPY --from=registry.cn-beijing.aliyuncs.com/yunionio/file-repo:v0.4.0 /opt/yunion/ansible-install-pkg /opt/yunion/ansible-install-pkg

ADD ./_output/alpine-build/bin/ansibleserver /opt/yunion/bin/ansibleserver