FROM python:alpine
RUN pip install --no-cache-dir redis
RUN pip install --no-cache-dir requests
COPY worker.py /
CMD ["python", "worker.py"]
