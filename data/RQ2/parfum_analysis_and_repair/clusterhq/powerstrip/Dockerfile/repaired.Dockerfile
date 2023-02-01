FROM        ubuntu:14.04

# Last build date - this can be updated whenever there are security updates so
# that everything is rebuilt
ENV         security_updates_as_of 2014-07-06

# Install security updates and required packages
RUN         apt-get -qy update
RUN         apt-get -qy upgrade
RUN apt-get -qy --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyasn1
RUN apt-get -qy --no-install-recommends install libyaml-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD         . /app

WORKDIR     /app

# Install requirements from the project's setup.py
RUN         python setup.py install

CMD         ["twistd", "-noy", "powerstrip.tac"]
