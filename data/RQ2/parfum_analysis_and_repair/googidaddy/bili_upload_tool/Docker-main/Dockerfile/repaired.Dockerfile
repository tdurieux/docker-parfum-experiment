# ARM architecture
# FROM flyingjoe/uvicorn-gunicorn-fastapi:latest
FROM tiangolo/uvicorn-gunicorn:python3.9

COPY ./main /app
WORKDIR /app
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y ca-certificates && \
    apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y ffmpeg && \
    pip install --no-cache-dir fastapi && \
    pip install --no-cache-dir -r /app/requirements.txt && rm -rf /var/lib/apt/lists/*;

CMD ["uvicorn", "--port", "20123", "--host", "0.0.0.0", "--reload", "main:app"]


