FROM geerlingguy/docker-ubuntu2004-ansible

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt-get -y update && DEBIAN_FRONTED=noninteractive TZ=Europe/London && apt-get -y --no-install-recommends install apache2 curl gpg gpg-agent && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install openssh-server && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -

RUN echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

RUN apt-get -y update && DEBIAN_FRONTED=noninteractive TZ=Europe/London

RUN apt-get -y --no-install-recommends install wazuh-agent && rm -rf /var/lib/apt/lists/*;


ENTRYPOINT ["/bin/bash", "-c" , "/var/ossec/bin/wazuh-control start && apache2ctl -D FOREGROUND"]
