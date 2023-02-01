FROM python:3.8

# install essential dependencies
RUN apt-get update -qq -y && apt-get install --no-install-recommends -y \
    build-essential \
    nodejs \
    npm \
    less \
    nano && rm -rf /var/lib/apt/lists/*;

# copy install script to bin
COPY ./dev_install /bin