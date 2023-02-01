ARG BASEIMAGE
FROM ${BASEIMAGE}
USER 0
RUN yum install -y python-devel gcc libffi-devel && pip install --no-cache-dir molecule && rm -rf /var/cache/yum
ARG NAMESPACEDMAN
ADD $NAMESPACEDMAN /namespaced.yaml
ADD build/test-framework/ansible-test.sh /ansible-test.sh
RUN chmod +x /ansible-test.sh
USER 1001
ADD . /opt/ansible/project
