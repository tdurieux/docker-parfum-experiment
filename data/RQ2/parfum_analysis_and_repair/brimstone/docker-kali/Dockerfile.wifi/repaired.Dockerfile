FROM brimstone/kali:latest

RUN apt update \
 && apt install -y --no-install-recommends \
	aircrack-ng cowpatty mfoc mfcuk libnfc-bin \
 && apt clean \
 && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/derv82/wifite /opt/wifite --depth 1 \
 && ln -s /opt/wifite/wifite.py /sbin/wifite
