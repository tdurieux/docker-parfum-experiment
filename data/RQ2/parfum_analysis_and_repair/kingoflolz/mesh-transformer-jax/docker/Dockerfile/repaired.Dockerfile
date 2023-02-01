# Have tested with a custom Ubuntu-1804 / Python 3.7 / Tensorflow 2.5.0 Base Image
# Not tested with this image.
FROM tensorflow/tensorflow:2.5.0
RUN apt update && \
    apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/
COPY . /app/
RUN git clone https://github.com/kingoflolz/mesh-transformer-jax && \
    pip install --no-cache-dir -r mesh-transformer-jax/requirements.txt && \
    pip install --no-cache-dir mesh-transformer-jax/ jax==0.2.12 && \
    pip install --no-cache-dir fastapi uvicorn requests aiofiles aiohttp && \
    ln -s /app/start.sh /start.sh

ENV PYTHONPATH /app:/app/mesh-transformer-jax:/usr/local/bin/python3
ENV PATH $PYTHONPATH:$PATH
ENV TOKENIZERS_PARALLELISM=true
EXPOSE 80

CMD ["/start.sh"]
