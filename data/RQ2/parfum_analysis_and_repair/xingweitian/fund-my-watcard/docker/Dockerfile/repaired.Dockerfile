FROM ubuntu

LABEL maintainer="fyuxin@uwaterloo.ca"

# Commands to install requirements
RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip python3-dev vim curl apt-utils \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --no-cache-dir fund-my-watcard && rm -rf /var/lib/apt/lists/*;

# Commands to install Chrome
RUN curl -f https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb \
    && dpkg -i /chrome.deb || apt-get install -yf \
    && rm /chrome.deb
