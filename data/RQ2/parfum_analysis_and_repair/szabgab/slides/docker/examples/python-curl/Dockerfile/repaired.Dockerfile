FROM python:3.8
RUN pip3 install --no-cache-dir requests
COPY curl.py .
ENTRYPOINT ["python3", "curl.py"]
