FROM python:3.7-slim
COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt update && apt install --no-install-recommends -y libmagic-dev && rm -rf /var/lib/apt/lists/*;
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
