FROM python:3.10.0a6-buster

LABEL name="CTF User Sim Container"

# Based on https://blog.jdriven.com/2021/05/create-a-docker-image-running-robot-framework/



# Install Robot Reqs
RUN apt-get update \
    && apt-get install --no-install-recommends -y xvfb wget ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 \
       libatspi2.0-0 libcups2 libdbus-1-3 libgbm1 libgtk-3-0 libnspr4 libnss3 \
       libxcomposite1 libxkbcommon0 libxrandr2 xdg-utils ntpdate openssl && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install robotframework && pip install --no-cache-dir robotframework-requests && pip install --no-cache-dir robotframework-selenium2library \
    && pip install --no-cache-dir xvfbwrapper && pip install --no-cache-dir robotframework-xvfb && pip install --no-cache-dir certifi && pip install --no-cache-dir asn1crypto \
    && pip install --no-cache-dir bcrypt && pip install --no-cache-dir robotframework-sshlibrary && pip install --no-cache-dir cryptography && pip install --no-cache-dir pyOpenSSL \
    && pip install --no-cache-dir idna && pip install --no-cache-dir requests[security]

# install chrome and chromedriver in one run command to clear build caches for new versions (both version need to match)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome*.deb \
    && rm google-chrome*.deb \
    && wget -q https://chromedriver.storage.googleapis.com/100.0.4896.60/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && rm chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin \
    && chmod +x /usr/local/bin/chromedriver



# Install Test Tools

RUN apt-get update \
    && apt-get install --no-install-recommends -y nmap gobuster curl hydra sqlmap moreutils && rm -rf /var/lib/apt/lists/*;


CMD ["bash", "/scripts/usersim.py"]