# Dockerfile for Yandex Transport Monitor Tests
# Architectures: armhf (Orange PI, Raspberry PI)
#                x86-64

# Use Ubuntu 18.04 as basis
FROM ubuntu:18.04

# ----- CHANGE THESE ARGUMENTS TO YOUR DESIRES ----- #
# -- ИЗМЕНИТЕ ДАННЫЕ АРГУМЕНТЫ ДЛЯ ВАШЕЙ СИТУАЦИИ -- #
# TimeZone / Часовой Пояс
ARG timezone=Europe/Moscow

# -------------------------------------------------- #

# Setting frontend to non-interactive, no questions asked, ESPECIALLY for locales.
ENV DEBIAN_FRONTEND=noninteractive

# Install all required software, right way.
# We're using all latest package versions here. Risky.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    locales \
    tzdata \

    chromium-browser \
    chromium-chromedriver \


    libpq-dev \



    libxml2-dev \
    libxslt1-dev \

    python3 \

    python3-pip && rm -rf /var/lib/apt/lists/*;

# Install required python packages
RUN pip3 install --no-cache-dir psycopg2-binary \
                 selenium \
                 setproctitle \
                 beautifulsoup4 \
                 lxml

# Install pytest, separately, so previous step will be cached
RUN pip3 install --no-cache-dir pytest \
                 pytest-progress \
                 pytest-rerunfailures \
                 pytest-timeout

# Dealing with goddamn locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

# Setting the goddamn TimeZone
ENV TZ=${timezone}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Cleaning
RUN apt-get clean

# Creating the user
RUN mkdir -p /home/transport_proxy
RUN useradd transport_proxy --home /home/transport_proxy --shell /bin/bash

# Copying the project
ADD yandex_transport_core/ /home/transport_proxy/yandex_transport_core
ADD transport_proxy.py /home/transport_proxy

# Copying tests
ADD tests/test* /home/transport_proxy/tests/
ADD execute_tests.sh /home/transport_proxy

# Setting permissions
RUN chown -R transport_proxy:transport_proxy /home/transport_proxy
WORKDIR /home/transport_proxy

# Setting up entry point for this container, it's designed to run as an executable.
# ENTRYPOINT HERE
USER transport_proxy:transport_proxy
CMD /home/transport_proxy/execute_tests.sh
