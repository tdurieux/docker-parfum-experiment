FROM python:3.9.1-slim

WORKDIR /app

# Copy in reqired files
COPY requirements-dev.txt ./

# Install Python Requirements
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements-dev.txt

# Install VIM and Bash completion
RUN apt-get update
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bash-completion && rm -rf /var/lib/apt/lists/*;

# Jupyter, from https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#docker-cmd
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
