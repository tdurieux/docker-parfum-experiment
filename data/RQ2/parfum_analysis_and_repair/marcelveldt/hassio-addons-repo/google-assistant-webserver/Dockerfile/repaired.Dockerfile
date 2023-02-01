FROM python:3.8-slim

RUN set -x \
    # Install required system packages
    && apt-get update && apt-get install -y --no-install-recommends \
        jq \
        tzdata \
        portaudio19-dev \
        libffi-dev \
        libssl-dev && rm -rf /var/lib/apt/lists/*;

# install python packages
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

EXPOSE 5000/tcp

VOLUME [ "/data" ]

WORKDIR /usr/src/app
COPY /app /usr/src/app/

CMD [ "python", "/usr/src/app/main.py" ]