FROM ubuntu:trusty-20170602

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN rm -vf /var/lib/apt/lists/*
RUN apt-get -y update

# system dependencies
RUN apt-get -y --no-install-recommends install \
        git \
        mysql-server \
        nginx \
        python-software-properties \
        software-properties-common \
        supervisor \
        curl && rm -rf /var/lib/apt/lists/*;

# for python 3.6
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get -y update

# python requirement dependencies
RUN apt-get -y --no-install-recommends install \
        python3.6 \

        build-essential \
        libpython3.6-dev \
        libssl-dev \
        libffi-dev && rm -rf /var/lib/apt/lists/*;


RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.6 -
RUN pip install --no-cache-dir virtualenv

ENV venvs=/root/.virtualenvs
ENV venv=$venvs/chaos
ENV chaosdir=/root/workspace/Chaos

RUN mkdir -p $chaosdir
RUN mkdir $venvs
RUN virtualenv $venv

ENV PATH="$venv/bin:$PATH"

WORKDIR $chaosdir

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

RUN rm /etc/nginx/sites-enabled/default

EXPOSE 80 8081
