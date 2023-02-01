FROM python:3.7

LABEL maintainer="Jakub Turek <jkbturek@gmail.com>"
LABEL "com.github.actions.name"="danger-python"
LABEL "com.github.actions.description"="Runs Python Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

# Install dependencies
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir poetry

RUN mkdir -p /usr/src/danger-python && rm -rf /usr/src/danger-python
COPY . /usr/src/danger-python
RUN cd /usr/src/danger-python && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev

ENTRYPOINT ["npx", "--package", "danger", "danger-python", "ci"]
