FROM ubuntu:latest
MAINTAINER docker@ekito.fr

RUN apt-get update \
  && apt-get -y --no-install-recommends install cron \
  && apt-get install --no-install-recommends -y gnupg2 \
  && apt-get -y --no-install-recommends install python3.6 \
  && apt-get install --no-install-recommends -y wget \
  && apt-get install --no-install-recommends -y python3-pip \
  && apt-get install --no-install-recommends -y python3-bs4 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy hello-cron file to the cron.d directory
COPY hello-cron /etc/cron.d/hello-cron
#COPY chromedriver . # not using this one because its for mac
COPY class_parser.py .
COPY departments.txt .
COPY d.txt .
COPY test.py .

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update && apt-get -y --no-install-recommends install python3-pip && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# install chromedriver
RUN apt-get install --no-install-recommends -yqq unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /app/

# set display port to avoid crash
ENV DISPLAY=:99

# upgrade pip
RUN pip3 install --no-cache-dir --upgrade pip

# install selenium
RUN pip3 install --no-cache-dir selenium

# this has been moved to docker-compose.yml
# Run the command on container startup
#CMD ["cron", "-f"]
