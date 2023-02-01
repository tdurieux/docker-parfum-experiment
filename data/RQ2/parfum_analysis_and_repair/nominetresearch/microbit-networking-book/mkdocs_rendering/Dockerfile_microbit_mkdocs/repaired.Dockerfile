FROM ubuntu:18.04

# system update
RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

# python pip


# we're done with package install
RUN rm -rf /var/lib/apt/lists/*

# mkdocs install
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir mkdocs
#RUN pip install mkdocs-material

# (expect mkdocs source loaded into /shared)
RUN mkdir /shared

# entrypoint script
COPY build.sh /
RUN chmod 755 /build.sh


ENV RUNNING_IN_DOCKER Yes


ENTRYPOINT ["/build.sh"]
