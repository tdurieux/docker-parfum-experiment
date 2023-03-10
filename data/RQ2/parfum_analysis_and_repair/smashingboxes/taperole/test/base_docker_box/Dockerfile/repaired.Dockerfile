# Start with the ubuntu image
FROM ubuntu:16.04

CMD ["bash"]

# Update apt cache
RUN apt-get -y update

# Install ansible dependencies
RUN apt-get install --no-install-recommends -y python-dev git aptitude sudo wget make zlib1g-dev libssl-dev build-essential libreadline-dev libyaml-dev libxml2-dev libcurl4-openssl-dev python-software-properties libffi-dev curl && rm -rf /var/lib/apt/lists/*;

# Install Ruby
WORKDIR /tmp
RUN wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.0.tar.gz
RUN tar -xvzf ruby-2.4.0.tar.gz && rm ruby-2.4.0.tar.gz
WORKDIR /tmp/ruby-2.4.0
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local
RUN make
RUN make install

# Add an authorized_keys file to the container since tape expects this
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Clone ansible repo (could also add the ansible PPA and do an apt-get install instead)
RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir ansible

# Set variables for ansible
WORKDIR /tmp/ansible
ENV PATH /tmp/ansible/bin:/usr/sbin:/sbin:/usr/bin:/bin:$PATH
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH

