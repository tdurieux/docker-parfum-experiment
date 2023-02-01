FROM python:3.6

RUN mkdir -p /app/pytel_bot
WORKDIR /app/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt && \
    apt-get update && \
    apt-get install -y --no-install-recommends fonts-liberation && \
    apt-get clean && \
    rm -rf /var/lib/apt && \
    rm -rf /var/cache/apt && \
    unlink /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime && rm -rf /var/lib/apt/lists/*;
COPY main.py insultos.txt insults.txt ./
COPY pytel_bot ./pytel_bot/

CMD python main.py
