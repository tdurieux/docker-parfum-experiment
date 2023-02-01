FROM ubuntu:14.04.4
RUN apt-get update && apt-get install --no-install-recommends -y xmlstarlet jq git apt-transport-https wget vim && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O- https://downloads.opennebula.org/repo/Ubuntu/repo.key | apt-key add - && echo "deb http://downloads.opennebula.org/repo/4.14/Ubuntu/14.04/ stable opennebula" > /etc/apt/sources.list.d/opennebula.list && apt-get -y update && apt-get -y --no-install-recommends install opennebula opennebula-node opennebula-sunstone && mkdir /var/run/one && chown -R oneadmin:oneadmin /var/run/one && rm -rf /var/lib/apt/lists/*;
ADD ./start-node /opt/docker-boot/
ADD ./conf.d /etc/docker-boot/conf.d/
RUN groupadd -g 998 docker && usermod -aG docker oneadmin && touch /var/log/onedock.log && chown oneadmin:oneadmin /var/log/onedock.log
RUN apt-get -y --no-install-recommends install curl && curl -f -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y libnfnetlink0 libsystemd-journal0 libapparmor1
ENTRYPOINT [ "/opt/docker-boot/start-node" ]
