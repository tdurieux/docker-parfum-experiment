FROM heroku/heroku:20

# avoid https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
ARG DEBIAN_FRONTEND=noninteractive

# install python 3.8
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential python3.8 python3.8-dev python3.8-venv python3-distutils && rm -rf /var/lib/apt/lists/*;

# install other packages
# pdftk is not available in this image yet
# see https://askubuntu.com/questions/1029450/how-to-install-pdftk-on-ubuntu-18-04-bionic
RUN apt-get -y --no-install-recommends install jq wkhtmltopdf xvfb cron && rm -rf /var/lib/apt/lists/*;

# install pip
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python3.8 /tmp/get-pip.py

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb

RUN gem install foreman

# do an upgrade to be up to date. run this periodically since unattended upgrades are disabled
RUN unattended-upgrade -d

# stop unattended upgrades
RUN apt-get remove unattended-upgrades -y && apt-get purge unattended-upgrades -y

# required by click on python3
# see https://click.palletsprojects.com/en/7.x/python3/
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Port is always 4000 for no good reason.
ENV PORT 4000
EXPOSE 4000
EXPOSE 22
ENTRYPOINT ["/usr/bin/dumb-init", "--", "gigalixir_run"]

RUN mkdir -p /app
RUN sed -i 's$root:x:0:0:root:/root:/bin/bash$root:x:0:0:root:/app:/bin/bash$' /etc/passwd
RUN mkdir -p /opt/gigalixir
RUN mkdir -p /release-config
RUN python3.8 -m venv /tmp/gigalixir
RUN chmod og+x /tmp/gigalixir/bin/activate
# copy over host keys so customers don't key host key verification check failed
ADD secrets/gigalixir-18/etc/ssh /etc/ssh

# overwrite ssh config with the one we really want although they're probably identical
COPY etc/ssh/sshd_config /etc/ssh/sshd_config
COPY bashrc /app/.bashrc
RUN cp /root/.profile /app/.profile
ADD . /opt/gigalixir
WORKDIR /opt/gigalixir

# Workaround for setuptools >= 60.0.0
# See https://github.com/pypa/setuptools/issues/2996
RUN SETUPTOOLS_USE_DISTUTILS=stdlib python3.8 setup.py install
WORKDIR /app


