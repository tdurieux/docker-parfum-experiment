FROM python:3.9.1

WORKDIR /app

COPY ./ ./

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED=1

CMD ["python3", "server.py"]