FROM ubuntu

RUN apt update && apt install --no-install-recommends git python3 python3-pip -y && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && rm -rf /var/lib/apt/lists/*;

ADD *.sh /
ADD hub-mirror /hub-mirror
ADD action.yml /

ENTRYPOINT ["/entrypoint.sh"]
