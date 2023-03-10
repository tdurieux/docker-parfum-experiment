FROM python:3.6

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade pip-tools
RUN pip install --no-cache-dir --upgrade virtualenv

VOLUME /app
WORKDIR /app

STOPSIGNAL SIGTERM

RUN echo "" >> ~/.bashrc && \
    echo 'source ~/.bashrc_mdstudio' >> ~/.bashrc

ENV PYENV_SHELL=/bin/bash

COPY .bashrc_mdstudio /root/.bashrc_mdstudio

CMD "bash"
