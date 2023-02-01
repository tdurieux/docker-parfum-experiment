FROM shykes/couchdb

MAINTAINER Gelnior <gelnior@free.fr>

# Python and build dependencies
RUN apt-get install --no-install-recommends -y python python-setuptools python-pip python-pycurl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev python-imaging build-essential git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt-dev supervisor && rm -rf /var/lib/apt/lists/*;

# Install newebe
RUN pip install --no-cache-dir git+git://github.com/gelnior/newebe.git

# Configure use
RUN groupadd newebe
RUN adduser --system --home /usr/local/var/newebe --ingroup newebe --gecos "Newebe system user" --shell /bin/false --quiet --disabled-password newebe

# Create folders
RUN mkdir -p /usr/local/etc/newebe/
RUN mkdir -p /usr/local/var/newebe/
RUN mkdir -p /usr/local/var/log/newebe/
RUN chown newebe:newebe /usr/local/etc/newebe/
RUN chown newebe:newebe /usr/local/var/log/newebe/
RUN chown newebe:newebe /usr/local/var/newebe/

# Set config
ADD config.yaml /usr/local/etc/newebe/
ADD supervisor.conf /etc/supervisor/

# Configure supervisor to daemonize the process.
ADD couchdb.conf /etc/supervisor/conf.d/
ADD newebe.conf /etc/supervisor/conf.d/

EXPOSE 8282
CMD ["/usr/bin/supervisord", "-n"]
