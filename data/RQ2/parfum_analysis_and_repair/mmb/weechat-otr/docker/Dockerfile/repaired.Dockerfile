FROM ubuntu

RUN apt-get update
RUN apt-get --assume-yes -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install pylint && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;

RUN easy_install pip
RUN pip install --no-cache-dir python-potr
