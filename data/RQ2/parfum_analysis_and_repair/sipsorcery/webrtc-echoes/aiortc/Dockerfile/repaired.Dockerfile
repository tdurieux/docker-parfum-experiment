FROM python:3.9
RUN apt update && apt install --no-install-recommends -y libopus-dev libsrtp2-dev libavformat-dev libvpx-dev libavdevice-dev libavfilter-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY ["aiortc", ""]
COPY ["html", "../html/"]
COPY ["aiortc/client.sh", "/client.sh"]
RUN chmod +x /client.sh
RUN pip install --no-cache-dir aiohttp aiortc
EXPOSE 8080
ENTRYPOINT python server.py
