FROM ubuntu:17.10

ARG workdir="/root"

RUN apt-get update && apt-get install --no-install-recommends -y \
	iproute2 python3 python3-requests python3-flask ebtables && rm -rf /var/lib/apt/lists/*;

# setup ebconfig
ADD ebconfig.py ${workdir}/ebconfig.py

CMD bash -c "/root/ebconfig.py /etc/nante-wan.conf"
