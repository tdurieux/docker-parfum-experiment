FROM python:3.9

# Install ansible amd ansible-test requirements
RUN pip3 install --no-cache-dir ansible mock pytest pytest-mock pytest-xdist pytest-forked pyyaml pytest-sugar netaddr

# Set up ansible collections directories for agent
RUN mkdir -p /code/ansible_collections/devscripts/agent
COPY ./agent /code/ansible_collections/devscripts/agent
RUN chmod -R 775 /code/ansible_collections/devscripts/agent
WORKDIR /code/ansible_collections/devscripts/agent
ENV ANSIBLE_COLLECTIONS_PATH=/code

# Copy pytest.ini to control pytest output
COPY ./agent/tests/pytest.ini /usr/local/lib/python3.9/site-packages/ansible_test/_data/pytest.ini

# Create files for playbook dry run integration tests.
COPY ./agent/tests/unit/plugins/modules/data/test_id_rsa.pub /root/.ssh/id_rsa.pub
COPY ./agent/tests/unit/plugins/modules/data/test_pull_secret.json /opt/dev-scripts/pull_secret.json
COPY ./agent/tests/unit/plugins/modules/data/test_ironic_nodes.json /opt/dev-scripts/ostest/ironic_nodes.json