ARG version=latest

FROM ghcr.io/pomo-mondreganto/forcad_base:${version}

########## CUSTOMIZE ##########

ENV PWNLIB_NOTERM=true

# uncomment blocks to enable features

### selenium (chromedriver) dependencies (from https://github.com/joyzoursky/docker-python-chromedriver) ###
################
#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
#RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
#RUN apt-get update \
#    && apt-get install -y --no-install-recommends google-chrome-stable unzip \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
#RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
################

COPY ./checkers/requirements.txt /checker_requirements.txt
RUN pip install --no-cache-dir -r /checker_requirements.txt

COPY ./checkers /checkers

########## END CUSTOMIZE ##########

COPY backend /app

COPY ./docker_config/celery/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER nobody

CMD ["/entrypoint.sh"]
