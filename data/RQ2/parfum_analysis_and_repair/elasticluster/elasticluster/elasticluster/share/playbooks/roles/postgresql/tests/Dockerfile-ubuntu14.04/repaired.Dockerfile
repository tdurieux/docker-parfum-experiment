FROM ubuntu:14.04
MAINTAINER ANXS

# Setup system with minimum requirements + ansible
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq python-apt python-pycurl python-pip python-dev locales && \
    echo 'en_US.UTF-8 UTF-8' > /var/lib/locales/supported.d/local && \
    pip install --no-cache-dir -q ansible==1.9.4 && rm -rf /var/lib/apt/lists/*;

# Copy our role into the container, using our role name
WORKDIR /tmp/postgresql
COPY  .  /tmp/postgresql

# Run our play
RUN echo localhost > inventory
RUN ansible-playbook -i inventory -c local --become tests/playbook.yml
