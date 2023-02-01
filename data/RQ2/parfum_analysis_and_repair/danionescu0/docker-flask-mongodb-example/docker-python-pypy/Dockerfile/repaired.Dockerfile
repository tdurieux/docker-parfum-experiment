FROM pypy:3-slim
ARG requirements
RUN apt-get update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN git clone https://github.com/danionescu0/docker-flask-mongodb-example.git flask-mongodb-example
WORKDIR /root/flask-mongodb-example/python
ENV PYTHONPATH "/root/flask-mongodb-example/python/common"
RUN pip install --no-cache-dir -qr $requirements
EXPOSE 5000
