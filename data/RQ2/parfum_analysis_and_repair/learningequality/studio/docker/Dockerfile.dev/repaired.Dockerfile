FROM ubuntu:bionic

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# Studio source directory ######################################################
RUN mkdir /src
WORKDIR /src
################################################################################


# System packages ##############################################################
ENV DEBIAN_FRONTEND noninteractive
# Default Python file.open file encoding to UTF-8 instead of ASCII, workaround for le-utils setup.py issue
ENV LANG C.UTF-8
RUN apt-get update --fix-missing && \
    apt-get -y --no-install-recommends install \
        curl fish man \
        python-minimal python3.6 python3-pip python3-dev \
        gcc libpq-dev make git gettext libjpeg-dev && rm -rf /var/lib/apt/lists/*;

# Ensure that python is using python3
# copying approach from official python images
ENV PATH /usr/local/bin:$PATH
RUN cd /usr/local/bin && \
  ln -s $(which python3) python && \
  ln -s $(which pip3) pip

# Download then install node
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
################################################################################


# Node packages ################################################################
RUN npm install -g yarn && npm cache clean --force
COPY ./package.json ./yarn.lock   /src/
RUN  yarn install --network-timeout 1000000 --pure-lockfile && yarn cache clean
################################################################################


# Python packages ##############################################################
COPY requirements.txt requirements-dev.txt   /src/
RUN pip install --no-cache-dir --upgrade pip

# install pinned deps from pip-tools into system
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt
RUN pip install --no-cache-dir --ignore-installed -r requirements-dev.txt
################################################################################


# Final cleanup ################################################################
RUN apt-get -y autoremove
################################################################################

CMD ["yarn", "run", "devserver"]
