FROM buildpack-deps:bionic

# One -q produces output suitable for logging (mostly hides
# progress indicators)
RUN apt-get -yqq update

# WARNING: DONT PUT A SPACE AFTER ANY BACKSLASH OR APT WILL BREAK
RUN apt-get -yqq --no-install-recommends install -o Dpkg::Options::="--force-confdef" -o \
  git-core \
  cloc dstat `# Collect resource usage statistics` \
  python-dev \
  python-pip \
  software-properties-common \
  libmysqlclient-dev `# Needed for MySQL-python` && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir colorama==0.3.1 requests MySQL-python psycopg2-binary pymongo docker==4.0.2 psutil

RUN apt-get install --no-install-recommends -yqq siege && rm -rf /var/lib/apt/lists/*;

# Fix for docker-py trying to import one package from the wrong location
RUN cp -r /usr/local/lib/python2.7/dist-packages/backports/ssl_match_hostname/ /usr/lib/python2.7/dist-packages/backports

ENV PYTHONPATH /FrameworkBenchmarks
ENV FWROOT /FrameworkBenchmarks

ENTRYPOINT ["python", "/FrameworkBenchmarks/toolset/run-tests.py"]
