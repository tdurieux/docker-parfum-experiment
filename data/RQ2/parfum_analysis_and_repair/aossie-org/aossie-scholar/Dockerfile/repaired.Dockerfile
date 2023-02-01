FROM node:12

RUN apt-get update; apt-get clean

RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;

RUN \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*