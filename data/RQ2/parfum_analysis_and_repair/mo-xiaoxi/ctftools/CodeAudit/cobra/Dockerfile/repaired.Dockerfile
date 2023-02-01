FROM ubuntu:xenial

COPY . /code/
WORKDIR /code

RUN apt-get update && apt-get install --no-install-recommends -y python-pip curl \
    && apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean \
    && pip install --no-cache-dir -r requirements.txt \
    && cp config.template config && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000
CMD ["python", "cobra.py", "-H", "0.0.0.0", "-P", "5000"]
