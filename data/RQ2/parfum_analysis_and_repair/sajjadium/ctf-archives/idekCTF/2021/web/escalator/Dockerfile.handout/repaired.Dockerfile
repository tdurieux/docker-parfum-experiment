FROM python:3.9-slim

RUN pip3 install --no-cache-dir flask mysql-connector-python gunicorn datetime

RUN apt update && \
      apt install --no-install-recommends -y curl gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y google-chrome-stable nodejs npm && \
      apt update && \
      rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer@11.0.0 && npm cache clean --force;

COPY escalator.py ./
COPY bot.js ./
COPY templates templates/
COPY static static/

ENV SECRET_KEY=[REDACTED]
ENV DB_HOST=127.0.0.1
ENV DB_USER=tracker
ENV DB_PASS=[REDACTED]
ENV DB=tracking
ENV FLAG=[REDACTED]
ENV KEY = [REDACTED]
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome

EXPOSE 1337

CMD mount -t tmpfs none /tmp && python3 /app/escalator.py