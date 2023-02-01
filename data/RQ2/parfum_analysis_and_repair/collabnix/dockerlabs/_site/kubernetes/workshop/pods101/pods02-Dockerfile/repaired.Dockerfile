FROM python:3.6
RUN pip install --no-cache-dir requests
COPY watcher.py /
ENTRYPOINT ["python", "/watcher.py"]
