FROM photon:4.0

RUN tdnf install -y redis && tdnf clean all