FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    python3 \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["environment/app.py"]
