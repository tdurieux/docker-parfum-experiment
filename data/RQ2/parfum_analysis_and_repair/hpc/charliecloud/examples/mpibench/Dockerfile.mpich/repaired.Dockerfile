# ch-test-scope: full
FROM mpich

RUN dnf install -y which \
 && dnf clean all

# Compile the Intel MPI benchmark