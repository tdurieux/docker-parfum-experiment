FROM armhf/debian:jessie

# clean and update dependencies
RUN apt-get clean && apt-get update

# get locale dependency
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;

# set locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN rm -vfr /var/lib/apt/lists/*
RUN apt-get -y update

# system dependencies
RUN apt-get -y --no-install-recommends install \
        git \
        nginx \
        python-software-properties \
        software-properties-common \
        supervisor \
        curl && rm -rf /var/lib/apt/lists/*;

# python requirement dependencies
RUN apt-get -y --no-install-recommends install \

        build-essential \
        libssl-dev \
        libffi-dev && rm -rf /var/lib/apt/lists/*;

# download python 3.6 source
RUN curl -f https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tgz -o Python-3.6.0.tgz -s && tar -xzvf Python-3.6.0.tgz && rm Python-3.6.0.tgz
RUN cd Python-3.6.0/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j 2 && make install

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py | python3.6 -
RUN pip3 install --no-cache-dir virtualenv

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

RUN printf "\
    ln -sf /root/workspace/Chaos/etc/chaos_supervisor.conf /etc/supervisor/conf.d/chaos.conf\n\
    ln -sf /root/workspace/Chaos/etc/nginx/chaos_errors /etc/nginx/sites-available/\n\
    ln -sf /etc/nginx/sites-available/chaos_errors /etc/nginx/sites-enabled/\n\

    service supervisor start\n\
    service nginx start\n\

    sleep 1\n\

    tail -F /root/workspace/Chaos/log/*"\
    >> /root/start_chaos.sh

EXPOSE 80 8081
ENTRYPOINT bash /root/start_chaos.sh
