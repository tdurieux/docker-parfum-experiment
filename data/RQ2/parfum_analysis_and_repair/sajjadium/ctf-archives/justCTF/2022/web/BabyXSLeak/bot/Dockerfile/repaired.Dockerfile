# build bot
FROM golang:1.18.2 as builder_manager
WORKDIR /code/
COPY . .
RUN go build -v .


FROM ubuntu:22.04
RUN apt-get update -y && apt-get install --no-install-recommends -y wget curl unzip gnupg && rm -rf /var/lib/apt/lists/*;

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# install chromedriver
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
        unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

COPY --from=builder_manager /code/bot /bin/bot

ENTRYPOINT ["/bin/bot"]
