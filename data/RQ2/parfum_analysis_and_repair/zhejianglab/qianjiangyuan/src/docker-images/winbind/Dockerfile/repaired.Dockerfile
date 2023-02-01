FROM ubuntu:16.04
MAINTAINER Hongzhi Li  <Hongzhi.Li@microsoft.com>


ADD krb5.conf /etc/krb5.conf
ADD nsswitch.conf /etc/nsswitch.conf

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        samba \
        cifs-utils \
        libnss-winbind \
        libpam-winbind \
        winbind \
        krb5-user \
        krb5-config && rm -rf /var/lib/apt/lists/*;

 RUN apt-get install --no-install-recommends -y apache2 libapache2-mod-wsgi && rm -rf /var/lib/apt/lists/*;

 RUN apt-get install --no-install-recommends -y \
        python-dev \
        python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask.restful

ADD smb.conf /etc/samba/smb.conf

ADD run.sh /run.sh
RUN chmod +x /run.sh

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD domaininfo /domaininfo

RUN ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
RUN rm /etc/apache2/mods-enabled/mpm_event.*


CMD /run.sh