FROM python:3.9-buster

ARG USERNAME

RUN true \
    && mkdir /var/log/Draupnir \
    && curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update \
    && apt-get install --no-install-recommends -y xinetd tini nodejs \
    && apt-get install --no-install-recommends -y nodejs \
    && rm -rf /var/cache/apt/archives \
    && useradd -m Draupnir \
    && npm install -g ganache-cli \
    && pip install --no-cache-dir web3 flask flask_cors gunicorn \
    && true && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt

ENV PYTHONPATH /home/Draupnir

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/home/Draupnir/entrypoint.sh"]
