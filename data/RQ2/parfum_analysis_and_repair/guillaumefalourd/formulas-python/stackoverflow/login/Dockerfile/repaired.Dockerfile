FROM python:3.8

RUN apt-get update -y && apt-get install --no-install-recommends -y curl bash sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://commons-repo.ritchiecli.io/install.sh | bash

USER root

RUN mkdir /rit
COPY . /rit
RUN sed -i 's/\r//g' /rit/set_umask.sh
RUN sed -i 's/\r//g' /rit/run.sh
RUN chmod +x /rit/set_umask.sh

WORKDIR /app
ENTRYPOINT ["/rit/set_umask.sh"]
CMD ["/rit/run.sh"]

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# install chromedriver
RUN apt-get install --no-install-recommends -yqq unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# set display port to avoid crash
ENV DISPLAY=:99