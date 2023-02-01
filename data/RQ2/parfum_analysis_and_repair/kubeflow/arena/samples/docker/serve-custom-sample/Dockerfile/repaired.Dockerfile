FROM happy365/fast-style-transfer-build as builder
FROM tensorflow/tensorflow:1.5.0-gpu
RUN mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bak && \
	apt-get update
RUN apt-get install --no-install-recommends apt-transport-https -y && \
	apt-get install --no-install-recommends git wget -y && \
	mv /etc/apt/sources.list.d.bak /etc/apt/sources.list.d && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir Pillow==3.4.2 && \
	pip install --no-cache-dir scipy==0.18.1 && \
	pip install --no-cache-dir numpy==1.11.2 && \
	pip install --no-cache-dir flask && \
	cd /root && \
	git clone https://github.com/floydhub/fast-style-transfer.git && \
	add-apt-repository ppa:jonathonf/ffmpeg-3 -y && \
	apt update && apt install --no-install-recommends -y ffmpeg libav-tools x264 x265 && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /input /input
RUN cp -a /root/fast-style-transfer/examples/style /output
WORKDIR /root/fast-style-transfer
