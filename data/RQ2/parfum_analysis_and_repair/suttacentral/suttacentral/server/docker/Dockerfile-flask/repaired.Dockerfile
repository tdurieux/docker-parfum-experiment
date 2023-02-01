FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y pngnq && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/sc/sockets
RUN mkdir -p /opt/sc/sc-flask
WORKDIR /opt/sc/sc-flask
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY *.* ./


