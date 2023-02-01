FROM tiangolo/uwsgi-nginx-flask:python3.8

# Install Chrome
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
  gnupg \
    --no-install-recommends \
    && curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# It won't run from the root user.
RUN groupadd chrome && useradd -g chrome -s /bin/bash -G audio,video chrome \
    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

# Install redis and dependencies
RUN apt-get -y --no-install-recommends install redis && rm -rf /var/lib/apt/lists/*;

COPY ./app/ /app
WORKDIR /app
RUN pip install --no-cache-dir -r ./requirements.txt
RUN chmod +x /app/start.sh
CMD ["sh", "-c", "/app/start.sh"]
