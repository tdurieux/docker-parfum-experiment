FROM python:3.8

ENV PYTHONUNBUFFERED=1 PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 PIP_NO_CACHE_DIR=1

ENV NODE_VERSION 14

RUN curl --proto '=https' --tlsv1.2 -fsLS https://deb.nodesource.com/setup_16.x | sh - \
        && apt install --no-install-recommends -y nodejs \
        && npm install --global npm \
        && npm install --global @vue/cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# install supervisord (supervisor-stdout is not py3 compatible in pypi)
RUN pip install --no-cache-dir supervisor git+https://github.com/coderanger/supervisor-stdout

# Sets work directory to /code
WORKDIR /code

# Allows docker to cache installed dependencies between builds
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./supervisord.conf /etc/supervisord.conf

# Adds our application code to the image
COPY ./ /code
