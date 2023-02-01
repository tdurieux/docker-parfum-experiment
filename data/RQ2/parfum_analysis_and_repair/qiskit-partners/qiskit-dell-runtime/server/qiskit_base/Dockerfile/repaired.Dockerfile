ARG DOCKER_REPO

FROM $DOCKER_REPO/python

RUN pip3 install --no-cache-dir qiskit >=0.31.0
RUN pip3 install --no-cache-dir qiskit-ibmq-provider >=0.13.0
