FROM python:3.7-slim
COPY / /app
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends build-essential libpoppler-cpp-dev pkg-config python-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
