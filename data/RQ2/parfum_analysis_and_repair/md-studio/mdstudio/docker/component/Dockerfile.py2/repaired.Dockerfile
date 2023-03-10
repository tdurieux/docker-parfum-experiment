FROM python:2.7

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade pip-tools
RUN pip install --no-cache-dir --upgrade virtualenv

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /app
WORKDIR /app

STOPSIGNAL SIGTERM

RUN echo "" >> ~/.bashrc && \
    echo 'source ~/.bashrc_component' >> ~/.bashrc

ENV PYENV_SHELL=/bin/bash

ADD .bashrc_component /root/.bashrc_component

CMD ["bash", "/docker-entrypoint.sh"]
