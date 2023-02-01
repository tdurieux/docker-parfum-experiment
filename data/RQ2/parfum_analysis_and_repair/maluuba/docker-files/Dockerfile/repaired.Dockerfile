from ubuntu

MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxslt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pip==1.4.1
RUN easy_install -U distribute
RUN apt-get clean
