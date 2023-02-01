FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -qy language-pack-en && rm -rf /var/lib/apt/lists/*;
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN echo "Etc/UTC" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install --no-install-recommends -y git-core libxml2-dev build-essential python python-dev wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y postgresql-client-9.1 postgresql-client-common libpq5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
RUN python ez_setup.py

RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir virtualenv uwsgi
