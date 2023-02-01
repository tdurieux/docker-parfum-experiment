FROM ubuntu:18.04
MAINTAINER DevOps "devops@medicmobile.org"


RUN echo "==> Installing Python dependencies" && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
            build-essential python-setuptools     \
            python python-pip python-dev          \
            libffi-dev  libssl-dev                \
            libxml2-dev libxslt1-dev zlib1g-dev   \
            git wget python-wheel curl && rm -rf /var/lib/apt/lists/*;

RUN echo "====> Installing cht-conf python stuff"    &&\
    python -m pip install git+https://github.com/medic/pyxform.git@medic-conf-1.17#egg=pyxform-medic

RUN curl -f -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g cht-conf && npm cache clean --force;

CMD ["tail", "-f", "/dev/null"]
