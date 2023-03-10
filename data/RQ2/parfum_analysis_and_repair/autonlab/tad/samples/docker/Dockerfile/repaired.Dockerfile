########## DON'T MODIFY THIS SECTION, SCROLL DOWN ###########
# The next configurations do some configuring that can take a
# bit of time, so best make modifications AFTER them to allow
# utilization of cached steps.
#
# Note: As of 2015/03/05 this is Ubuntu 14.04.
FROM java:7
MAINTAINER Anthony Wertz <awertz@cmu.edu>

#------------ Install development software --------------#
RUN apt-get update
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-numpy git curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rabbitmq-server && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir celery
RUN pip install --no-cache-dir fisher elasticsearch
RUN pip install --no-cache-dir flask flask_restful

#------------- Pull software --------------#
RUN mkdir -p /service/build
WORKDIR /service/build
RUN ls
RUN git clone https://github.com/autonlab/tad.git

# Build and install TAD library.
RUN ln -s /service/build/tad/service /service/tad

#------------- Service Configuration --------------#
WORKDIR /

# Expose the service port.
EXPOSE 5000

# Copy service applications.
COPY service-scripts/. /service/

# Create the service entry point.
ENTRYPOINT ["/service/run"]
