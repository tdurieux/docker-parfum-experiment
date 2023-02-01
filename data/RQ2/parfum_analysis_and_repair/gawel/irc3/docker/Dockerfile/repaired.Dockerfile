FROM python:3.7

RUN adduser --disabled-password --gecos '' irc3

RUN echo build \
    && cd /usr/src && git clone https://github.com/gawel/irc3.git \
    && cd /usr/src/irc3 && pip install --no-cache-dir ipython && pip install --no-cache-dir -e .[test] \
    && mkdir -p /usr/src/bot && chown -R irc3:irc3 /usr/src/bot && rm -rf /usr/src/bot

WORKDIR /usr/src/bot

ONBUILD COPY . /usr/src/bot

USER irc3

CMD ["/usr/local/bin/irc3", "config.ini"]
