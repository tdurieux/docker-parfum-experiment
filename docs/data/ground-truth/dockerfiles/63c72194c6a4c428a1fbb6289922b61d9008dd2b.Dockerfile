# base-image for python on any machine using a template variable,
# see more about dockerfile templates here:http://docs.resin.io/pages/deployment/docker-templates
FROM balenalib/%%RESIN_MACHINE_NAME%%-python:3.7

# use apt-get if you need to install dependencies,
# for instance if you need ALSA sound utils, just uncomment the lines below.
# RUN apt-get update && apt-get install -yq \
#    alsa-utils libasound2-dev && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME ["/sys/fs/cgroup", "/sys/fs/cgroup/systemd", "/tmp", "/run", "/run/lock"]

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY Pipfile Pipfile.lock ./

# pip install python deps from requirements.txt on the resin.io build server
RUN pip3 install --upgrade pip setuptools pipenv
RUN apt-get update && apt-get install -yq gcc libc-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pipenv install --system --deploy

# This will copy all files in our root to the working  directory in the container
COPY . ./

# Remove warnings
ENV PYTHONWARNINGS="ignore"

# bond.py will run when container starts up on the device
CMD ["python", "prodconsume.py"]
#CMD ["/bin/sh"]
