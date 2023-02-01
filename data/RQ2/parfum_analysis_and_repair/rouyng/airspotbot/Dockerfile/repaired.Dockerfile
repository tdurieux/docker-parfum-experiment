FROM python:3.10-alpine
COPY . /src
WORKDIR /src
RUN apk add --no-cache --virtual .build-deps gcc libc-dev libffi-dev rust cargo openssl-dev
RUN apk add --no-cache chromium chromium-chromedriver
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apk del .build-deps

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

CMD ["python3", "-m", "airspotbot"]