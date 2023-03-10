ARG registry
FROM $registry/labtainer.wireshark2
LABEL description="This is base Docker image for the Labtainer server that receives tcpdumps from a tap component."
ADD system/bin/labdump_server.py /bin/
ADD system/bin/sharktap /bin/
ADD system/lib/systemd/system/labdump.service /lib/systemd/system/
ADD system/etc/systemd/system/labdump.service /etc/systemd/system/
RUN systemctl enable labdump.service