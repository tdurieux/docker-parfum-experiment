# Dockerfile should instantiate AWS Project with configurable plugins
FROM python:3.8
MAINTAINER Netflix Security
WORKDIR /apps/consoleme
# NODE_OPTIONS meeded to increase memory size of Node for the `yarn build` step. The Monaco Editor
# appears to be the culprit requiring this.
ENV NODE_OPTIONS="--max-old-space-size=20000"
ENV SETUPTOOLS_USE_DISTUTILS=stdlib

# Install OS dependencies
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt clean
RUN apt update && apt install --no-install-recommends -y \
    build-essential \
    libxml2-dev \
    libxmlsec1-dev \
    libxmlsec1-openssl \
    musl-dev \
    libcurl4-nss-dev \
    python3-dev \
    nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install yarn -g && npm cache clean --force;
# Install watchdog. Used to automatically restart ConsoleMe in Docker, for development.
RUN pip install --no-cache-dir watchdog argh

# Run ConsoleMe tornado server using configuration
COPY . /apps/consoleme
RUN pip install --no-cache-dir -U setuptools pip
RUN pip install --no-cache-dir -r requirements.txt -r requirements-test.txt
RUN pip install --no-cache-dir -e .

# Install SPA frontend
RUN yarn --cwd ui
RUN yarn --cwd ui build:prod

CMD python scripts/retrieve_or_decode_configuration.py; consoleme
EXPOSE 8081
