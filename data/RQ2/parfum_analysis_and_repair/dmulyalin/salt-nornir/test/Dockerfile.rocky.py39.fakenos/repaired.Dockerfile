FROM rockylinux:8.5

# install misc libs
RUN dnf install -y python3.9 nano tree

# do python libs installation
RUN python3 -m pip install pip --upgrade

# run FakeNOS installation from local files
COPY fakenos/ /tmp/fakenos/
RUN python3 -m pip install /tmp/fakenos/ --upgrade

# copy inventory across for initial start
COPY salt_nornir/test/fakenos_inventory/fakenos_inventory.yaml /tmp/fakenos_inventory/fakenos_inventory.yaml

ENTRYPOINT fakenos -i /tmp/fakenos_inventory/fakenos_inventory.yaml