FROM local-only/dag-installer:0.1.0

LABEL IMAGE="dag-federated-setup-node-test"
LABEL VERSION="0.1.0"
LABEL CI_IGNORE="False"

COPY files/dag_federated_setup_node_test.py /tmp/dags/
COPY files/federated_setup_node_test /tmp/dags/federated_setup_node_test