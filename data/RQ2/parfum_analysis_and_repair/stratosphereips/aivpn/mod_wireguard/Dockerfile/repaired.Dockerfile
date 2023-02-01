FROM lscr.io/linuxserver/wireguard
LABEL Description="This image is used to provide the AI VPN WireGuard VPN." Vendor="Civilsphere Project" Version="0.1" Maintainer="civilsphere@aic.fel.cvut.cz"
RUN apt update && apt install --no-install-recommends -y python3 tcpdump && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code
RUN cp add-peer /app/add-peer
RUN cp del-peer /app/del-peer
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["python3", "mod_wireguard.py"]
