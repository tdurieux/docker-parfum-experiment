FROM python:3.6

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libopus-dev \
    libav-tools \
    tesseract-ocr && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz \
        | tar xJ --strip-components=1 -C /usr/ && \
    ACCEPT_HIGHCHARTS_LICENSE=YES npm i -g highcharts-export-server --unsafe-perm && npm cache clean --force;

ADD . /app
WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt ./
RUN pip install \
    --no-cache-dir \
    -r requirements.txt

CMD [ \
    "python3", "src/main.py", \
    "--plugin-path", "plugins", \
    "--config-path", "config.yaml" \
]
