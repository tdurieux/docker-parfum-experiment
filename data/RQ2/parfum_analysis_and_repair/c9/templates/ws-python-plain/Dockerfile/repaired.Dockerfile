FROM cloud9/workspace
MAINTAINER Cloud9 IDE, inc. <info@c9.io>

# Python2
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-setuptools ipython \
    python-scipy python-matplotlib python-virtualenv virtualenvwrapper && rm -rf /var/lib/apt/lists/*;

# Python3
RUN apt-get install --no-install-recommends -y python3 python3-dev python3-pip python3-setuptools \
    ipython3 python3-scipy python3-matplotlib && rm -rf /var/lib/apt/lists/*;

# Alternative python versions
RUN apt-get install --no-install-recommends -y python3.5-complete && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir lpthw.web

ADD ./files/workspace /home/ubuntu/workspace

RUN chown -R ubuntu:ubuntu /home/ubuntu/workspace

ADD ./files/check-environment /.check-environment/python-plain
