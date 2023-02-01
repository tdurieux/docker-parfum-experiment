FROM python:3.6
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt
COPY *.py /app/
WORKDIR /app
CMD ["pytest", "-v", "--reruns", "3", "--only-rerun", "ConnectionError"]
