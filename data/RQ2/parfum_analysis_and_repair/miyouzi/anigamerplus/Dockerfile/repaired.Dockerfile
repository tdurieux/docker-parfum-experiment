FROM python:3

COPY . /app
WORKDIR /app
RUN set -x \
    && apt update \
    && apt install --no-install-recommends g++ gcc libevent-dev libxslt-dev ffmpeg -y \
    && pip3 install --no-cache-dir greenlet lxml \
    && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;
EXPOSE 5000
CMD python3 aniGamerPlus.py
