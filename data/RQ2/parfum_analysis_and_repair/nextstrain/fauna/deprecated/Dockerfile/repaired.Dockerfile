# nextstrain-db dockerfile

FROM ubuntu:14.04
MAINTAINER Trevor Bedford <trevor@bedford.io>
RUN apt-get -y update

# wget
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# python
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpng-dev libfreetype6-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# python dependencies
RUN pip install --no-cache-dir rethinkdb==2.2.0.post2
RUN pip install --no-cache-dir biopython==1.69

# NEED TO INSTALL RETHINKDB COMMAND

# nextstrain-db
RUN git clone https://github.com/nextstrain/fauna.git /fauna
WORKDIR /fauna/

# update
ADD http://www.timeapi.org/utc/now /tmp/bustcache
RUN git pull

# default process
CMD python -u vdb/flu_download.py -db vdb -v flu --select locus:HA subtype:h3n2 --interval collection_date:2016-01-01,2016-01-15 --fstem h3n2
