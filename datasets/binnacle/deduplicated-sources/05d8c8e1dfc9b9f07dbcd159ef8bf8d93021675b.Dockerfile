FROM ubuntu:16.04
MAINTAINER John Chilton <jmchilton@gmail.com>

ARG CHROME_VERSION="google-chrome-stable"
ARG CHROME_DRIVER_VERSION="latest"

# TODO: merge with first ENV statement.
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    MYSQL_MAJOR=5.7 \
    POSTGRES_MAJOR=9.5 \
    GALAXY_ROOT=/galaxy \
    GALAXY_VIRTUAL_ENV=/galaxy_venv

# Pre-install a bunch of packages to speed up ansible steps.
RUN apt-get update -y && apt-get install -y software-properties-common apt-transport-https curl && \
    apt-add-repository -y ppa:ansible/ansible && \
    curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -  && \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 && \
    echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections && \
    apt-get update -y && \
    apt-get install -y libpq-dev postgresql postgresql-client \
            ansible wget mysql-server="${MYSQL_MAJOR}"* libmysqlclient-dev="${MYSQL_MAJOR}"* \
            slurm-llnl libmunge-dev slurm-drmaa-dev ant atop axel bioperl cmake curl \
            g++ gcc gfortran git-core htop iftop iotop ipython libffi-dev liblapack-dev \
            libncurses5-dev libopenblas-dev libpam0g-dev libpq-dev libsparsehash-dev make \
            mercurial nginx-extras nmon patch postgresql postgresql \
            postgresql-client python-boto python-dev \
            python-prettytable python-psycopg2 python-virtualenv python-pip \
            rsync slurm-drmaa-dev swig sysstat unzip \
            autoconf automake build-essential libatlas-base-dev libblas-dev openssl \
            bzip2 \
            ca-certificates \
            openjdk-8-jre-headless \
            tzdata \
            sudo \
            locales \
            xvfb \
            ${CHROME_VERSION:-google-chrome-stable} \
            wget zlib1g-dev nodejs && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g grunt grunt-cli

RUN mkdir -p /tmp/ansible && \
    mkdir -p /opt/galaxy/db && \
    chown -R postgres:postgres /opt/galaxy/db && \
    sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf

ADD start_mysql.sh /opt/galaxy/start_mysql.sh
ADD ansible_vars.yml /tmp/ansible/ansible_vars.yml
ADD provision.yml /tmp/ansible/provision.yml

RUN mkdir /etc/galaxy && cd /tmp/ansible && mkdir roles && \
    mkdir roles/galaxyprojectdotorg.galaxy-os && \
    wget --quiet -O- https://github.com/galaxyproject/ansible-galaxy-os/archive/master.tar.gz | tar -xzf- --strip-components=1 -C roles/galaxyprojectdotorg.galaxy-os && \
    mkdir roles/galaxyprojectdotorg.cloudman-database && \
    wget --quiet -O- https://github.com/galaxyproject/ansible-cloudman-database/archive/master.tar.gz | tar -xzf- --strip-components=1 -C roles/galaxyprojectdotorg.cloudman-database && \
    mkdir roles/galaxyprojectdotorg.galaxy && \
    wget --quiet -O- https://github.com/galaxyproject/ansible-galaxy/archive/master.tar.gz | tar -xzf- --strip-components=1 -C roles/galaxyprojectdotorg.galaxy && \
    mkdir roles/galaxyprojectdotorg.galaxy-extras && \
    wget --quiet -O- https://github.com/galaxyproject/ansible-galaxy-extras/archive/dynamic_uwsgi_config.tar.gz | tar -xzf- --strip-components=1 -C roles/galaxyprojectdotorg.galaxy-extras && \
    mkdir roles/galaxyprojectdotorg.galaxy-toolshed && \
    wget --quiet -O- https://github.com/galaxyproject/ansible-galaxy-toolshed/archive/master.tar.gz | tar -xzf- --strip-components=1 -C roles/galaxyprojectdotorg.galaxy-toolshed && \
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/ansible/provision.yml --tags=image -c local -e "@ansible_vars.yml" && \
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/ansible/provision.yml --tags=database -c local -e "@ansible_vars.yml" && \
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/ansible/provision.yml --tags=galaxy -c local -e "@ansible_vars.yml" && \
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/ansible/provision.yml --tags=toolshed -c local -e "@ansible_vars.yml" && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd $GALAXY_ROOT && \
    ./scripts/common_startup.sh || { echo "common_startup.sh failed"; exit 1; } && \
    dev_requirements=./lib/galaxy/dependencies/dev-requirements.txt && \
    [ -f $dev_requirements ] && $GALAXY_VIRTUAL_ENV/bin/pip install -r $dev_requirements

RUN . $GALAXY_VIRTUAL_ENV/bin/activate && \
    pip install psycopg2 && \
    pip install mysql && \
    cd $GALAXY_ROOT && \
    echo "Prepopulating postgres database" && \
    su -c '/usr/lib/postgresql/${POSTGRES_MAJOR}/bin/pg_ctl -o "-F" start -D /opt/galaxy/db' postgres && \
    sleep 3 && \
    GALAXY_CONFIG_DATABASE_CONNECTION="postgresql://root@localhost:5930/galaxy" bash create_db.sh && \
    echo "Prepopulating sqlite database" && \
    GALAXY_CONFIG_DATABASE_CONNECTION="sqlite:////opt/galaxy/galaxy.sqlite" bash create_db.sh && \
    sh /opt/galaxy/start_mysql.sh && \
    echo "Prepopulating mysql database" && \
    GALAXY_CONFIG_DATABASE_CONNECTION="mysql://galaxy:galaxy@localhost/galaxy?unix_socket=/var/run/mysqld/mysqld.sock" bash create_db.sh && \
    echo "Prepopulating toolshed postgres database" && \
    TOOL_SHED_CONFIG_DATABASE_CONNECTION="postgresql://root@localhost:5930/toolshed" bash create_db.sh tool_shed && \
    echo "Prepopulating toolshed sqlite database" && \
    TOOL_SHED_CONFIG_DATABASE_CONNECTION="sqlite:////opt/galaxy/toolshed.sqlite" bash create_db.sh tool_shed && \
    echo "Prepopulating toolshed mysql database" && \
    TOOL_SHED_CONFIG_DATABASE_CONNECTION="mysql://galaxy:galaxy@localhost/toolshed?unix_socket=/var/run/mysqld/mysqld.sock" bash create_db.sh tool_shed

# bcftools for Galaxy.
RUN mkdir -p /tmp/install && \
    cd /tmp/install && \
    wget https://github.com/samtools/bcftools/releases/download/1.2/bcftools-1.2.tar.bz2 && \
    tar xvjf bcftools-1.2.tar.bz2 && \
    cd bcftools-1.2 && \
    make && \
    make install && \
    cd && rm -rf /tmp/install

#========================================
# Add Selenium user with passwordless sudo
#========================================
RUN useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd

USER seluser

#==========
# Selenium
#==========
RUN  sudo mkdir -p /opt/selenium \
  && sudo chown seluser:seluser /opt/selenium \
  && wget --no-verbose https://selenium-release.storage.googleapis.com/3.6/selenium-server-standalone-3.6.0.jar \
    -O /opt/selenium/selenium-server-standalone.jar

USER root

#==============================
# Scripts to run Selenium Node
#==============================
COPY selenium/entry_point.sh selenium/functions.sh selenium/wrap_chrome_binary selenium/generate_config /opt/bin/

RUN /opt/bin/wrap_chrome_binary

USER seluser

RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

RUN /opt/bin/generate_config > /opt/selenium/config.json

#============================
# Some configuration options
#============================
ENV SCREEN_WIDTH=1360 \
    SCREEN_HEIGHT=1020 \
    SCREEN_DEPTH=24 \
    DISPLAY=:99.0 \
    NODE_MAX_INSTANCES=1 \
    NODE_MAX_SESSION=1 \
    NODE_PORT=5555 \
    NODE_REGISTER_CYCLE=5000 \
    NODE_POLLING=5000 \
    NODE_UNREGISTER_IF_STILL_DOWN_AFTER=60000 \
    NODE_DOWN_POLLING_LIMIT=2 \
    NODE_APPLICATION_NAME="" \
    DBUS_SESSION_BUS_ADDRESS=/dev/null

USER root

ADD run_test_wrapper.sh /usr/local/bin/run_test_wrapper.sh

EXPOSE :9009
EXPOSE :8080
EXPOSE :80

ENTRYPOINT ["/bin/bash", "/usr/local/bin/run_test_wrapper.sh"]
