# production environment
FROM python:3.7-slim
ENV PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install nginx vim -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt --no-cache-dir
EXPOSE 8000
STOPSIGNAL SIGTERM
CMD ["/code/start_server.dev.sh"]
