FROM ubuntu:latest
FROM python:3.8.10
ARG CONTAINER_HOME
ARG HOST_HOME
ENV HOME=$CONTAINER_HOME
RUN mkdir -p $CONTAINER_HOME/
RUN apt-get update && apt-get -y --no-install-recommends install git curl vim less && rm -rf /var/lib/apt/lists/*;
WORKDIR $CONTAINER_HOME

# House keeping
RUN mkdir -p /usr/local/bin
RUN git clone https://github.com/so-fancy/diff-so-fancy.git
RUN ln -s $CONTAINER_HOME/diff-so-fancy/diff-so-fancy /usr/local/bin/diff-so-fancy

# Manually install reqs
COPY . agentos
WORKDIR ./agentos/example_agents/acme_r2d2/
RUN pip install --no-cache-dir -r requirements.txt
