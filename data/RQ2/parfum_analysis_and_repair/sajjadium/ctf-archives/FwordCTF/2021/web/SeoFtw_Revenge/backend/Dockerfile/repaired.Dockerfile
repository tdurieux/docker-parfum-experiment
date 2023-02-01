FROM python:3.7.3-slim
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
COPY . /app
WORKDIR /app
ENTRYPOINT ["./start.sh"]

