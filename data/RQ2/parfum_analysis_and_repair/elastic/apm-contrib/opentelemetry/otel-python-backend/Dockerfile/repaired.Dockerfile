FROM python:3

WORKDIR /app
ADD . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "server.py"]

