FROM ubuntu:14.04
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install dependencies
RUN \
  apt-get update && \
  apt-get -y --no-install-recommends install build-essential && \
  apt-get -y --no-install-recommends install python-pip && \
  apt-get -y --no-install-recommends install libxml2-dev libxslt1-dev python-dev && \
  apt-get -y --no-install-recommends install liblapack3 libgfortran3 libumfpack5.6.2 && \
  apt-get -y --no-install-recommends install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose && \
  apt-get -y --no-install-recommends install unzip && \
  apt-get -y --no-install-recommends install libpq-dev python-dev && \
  apt-get -y --no-install-recommends install libpq-dev && \
  apt-get -y --no-install-recommends install gfortran libblas-dev liblapack-dev && \
  apt-get -y --no-install-recommends install libfreetype6-dev libpng12-dev libqhull-dev libfreetype6 && \
  apt-get -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;

# Set work directories
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install requirements
COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

# Copy files to Dockerfile
COPY ./clatoolkit_project /usr/src/app
