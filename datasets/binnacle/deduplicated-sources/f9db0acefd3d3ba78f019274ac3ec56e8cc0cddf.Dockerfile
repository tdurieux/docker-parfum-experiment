FROM janitortechnology/ubuntu-dev
MAINTAINER Benjamin Bouvier <public@benj.me>

# Global install of weboob.
USER root

# Weboob and its dependencies.
RUN apt-get update && \
    apt-get install -y python python-dev libffi-dev \
    libxml2-dev libxslt-dev libyaml-dev libtiff-dev libjpeg-dev zlib1g-dev \
    libfreetype6-dev libwebp-dev build-essential gcc g++ wget mupdf-tools;

RUN cd /tmp && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python ./get-pip.py && \
    pip install -U setuptools && \
    pip install html2text simplejson BeautifulSoup PyExecJS pdfminer

RUN git clone https://git.weboob.org/weboob/devel /tmp/weboob \
    && cd /tmp/weboob \
    && python ./setup.py install \
    && rm -rf /tmp/weboob

# Setup kresus layout.
USER user
RUN mkdir -p /home/user/kresus/data

# Install app and dependencies.
WORKDIR /home/user/kresus
RUN git clone https://framagit.org/kresusapp/kresus app

WORKDIR /home/user/kresus/app
RUN npm install && make build

# Useful environment variables.
RUN echo "\n# Kresus configuration." >> /home/user/.bashrc \
 && echo "export KRESUS_URL_PREFIX=/`cat /proc/self/cgroup | grep docker | head -n 1 | sed 's_^.*docker\/__'`/\$PORT" >> /home/user/.bashrc

# Configure Cloud9 to use Kresus's source directory as workspace (-w).
RUN sudo sed -i "s/-w \/home\/user/-w \/home\/user\/kresus\/app/" /etc/supervisord.conf

# Configure Janitor for Kresus
ADD janitor.json /home/user/
RUN sudo chown user:user /home/user/janitor.json

ADD config-janitor.ini /home/user/kresus/app/config.ini
RUN sudo chown user:user /home/user/kresus/app/config.ini

# Expose the ports on which Kresus and the webpack-dev-server will be running.
EXPOSE 8080 9876

# Become root again so that supervisord is run with the right permissions.
USER root
