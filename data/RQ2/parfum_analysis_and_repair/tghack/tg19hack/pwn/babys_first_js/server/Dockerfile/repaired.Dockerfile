FROM ubuntu:bionic

RUN apt update && apt install --no-install-recommends -y python3 xinetd && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -s /bin/bash tghack

COPY d8 /home/tghack
RUN chmod +x /home/tghack/d8

COPY flag.txt /home/tghack
RUN chmod 644 /home/tghack/flag.txt

COPY js.xinetd /etc/xinetd.d/js
RUN chmod 644 /etc/xinetd.d/js

COPY wrap.sh /opt/wrap.sh
RUN chmod 755 /opt/wrap.sh

RUN chown -R root:root /home/tghack
COPY service.py /home/tghack
RUN chmod +x /home/tghack/service.py

CMD service xinetd start && /bin/bash
