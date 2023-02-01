FROM tool-xterm:latest

USER root
RUN apt-get update && apt-get install --no-install-recommends -y net-tools netcat john nmap vim hydra zip telnet ftp steghide && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tshark && rm -rf /var/lib/apt/lists/*;

COPY sqlmap.zip /tmp
RUN unzip /tmp/sqlmap.zip -d /opt
RUN echo 'export SQLMAP_HOME=/opt/sqlmap'>> /home/yolo/.bashrc
RUN echo 'export PATH=$PATH:$SQLMAP_HOME'>> /home/yolo/.bashrc
RUN echo 'unset $(env |grep  npm_ | cut -d"=" -f1)' >> /home/yolo/.bashrc
RUN echo 'alias sqlmap=sqlmap.py'>> /home/yolo/.bashrc
USER yolo
COPY --chown=yolo:yolo challenges /home/yolo/challenges
