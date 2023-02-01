FROM python:3.7-buster

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# INSTALLATION

# Add repository for node
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

# Install dependencies
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y nodejs libgeos-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Get the Tasking Manager
ARG branch=develop
RUN git clone --depth=1 git://github.com/hotosm/tasking-manager.git \
	--branch $branch /usr/src/app

## SETUP

# Setup backend dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Setup and build frontend
RUN cd frontend && npm install && npm run build && npm cache clean --force;

# INITIALIZATION

EXPOSE 5000
CMD ["python", "manage.py", "runserver", "-h", "0.0.0.0"]
