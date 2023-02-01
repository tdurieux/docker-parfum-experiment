# ch-test-scope: full
FROM openmpi

RUN dnf install -y which \
 && dnf clean all

# Compile the Intel MPI benchmark