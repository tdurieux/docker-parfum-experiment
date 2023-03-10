FROM python:3.8-slim

RUN pip install --no-cache-dir tomodachi

COPY app /app
WORKDIR /app

ENV PYTHONUNBUFFERED=1

CMD ["tomodachi", "run", "service.py", "--production"]
