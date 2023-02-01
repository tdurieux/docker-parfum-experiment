FROM python:slim

COPY app /app

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/app/p2pool_statistics.py"]
