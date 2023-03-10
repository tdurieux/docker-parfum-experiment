FROM ansible/ansible-runner

RUN yum remove -y ansible python-idna
RUN pip uninstall ansible-runner -y

RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir ansible ansible-runner openshift kubernetes ansible-runner-http idna==2.7

RUN mkdir -p /etc/ansible /usr/share/ansible/openshift \
    && echo "localhost ansible_connection=local" > /etc/ansible/hosts \
    && echo '[defaults]' > /etc/ansible/ansible.cfg \
    && echo 'roles_path = /opt/ansible/roles' >> /etc/ansible/ansible.cfg \
    && echo 'library = /usr/share/ansible/openshift' >> /etc/ansible/ansible.cfg

ENV OPERATOR=/usr/local/bin/ansible-operator \
    USER_UID=1001 \
    USER_NAME=ansible-operator\
    HOME=/opt/ansible

# install operator binary
ADD build/_output/bin/ansible-operator ${OPERATOR}

COPY bin /usr/local/bin
COPY library/k8s_status.py /usr/share/ansible/openshift/
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}
