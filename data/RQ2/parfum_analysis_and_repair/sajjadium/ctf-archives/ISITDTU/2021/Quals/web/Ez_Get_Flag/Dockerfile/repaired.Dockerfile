FROM python:3.8-slim

RUN useradd -m ctf

WORKDIR /ssti

COPY files/ .
COPY flag /
COPY iptables.sh /root
# COPY setup.sh /root

ENV PORT 5000
RUN apt update -y \
    && apt install --no-install-recommends iptables -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --upgrade --no-cache-dir -r requirements.txt
RUN apt install --no-install-recommends sqlite3 -y && rm -rf /var/lib/apt/lists/*;

RUN chown -R root:ctf /ssti && \
    chmod 750 /ssti /ssti/app.py \
    && chmod +x /root/iptables.sh \
    && /root/iptables.sh

USER ctf

CMD ["/usr/local/bin/python", "/ssti/app.py"]

EXPOSE 5000
