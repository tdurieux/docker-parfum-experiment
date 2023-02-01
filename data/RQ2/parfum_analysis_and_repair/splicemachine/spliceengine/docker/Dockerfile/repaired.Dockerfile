FROM maven:3.6.3-jdk-8

# nc is used in start-splice-cluster to check if connection is opened -> service is ready
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /usr/local/bin/se-entrypoint.sh
RUN chmod +x /usr/local/bin/se-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/se-entrypoint.sh" ]

RUN adduser --disabled-password --gecos '' splice
USER splice
COPY bashrc.sh /home/splice/.bashrc
