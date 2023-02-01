FROM macadmins/sal:latest
MAINTAINER Graham Gilbert <graham@grahamgilbert.com>

RUN apt-get update && apt-get install --no-install-recommends -y python-setuptools python-dev libxmlsec1-dev libxml2-dev xmlsec1 python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir djangosaml2==0.18.1

ADD attributemaps /home/app/sal/sal/attributemaps
RUN mv /home/app/sal/sal/urls.py /home/app/sal/sal/origurls.py
ADD urls.py /home/app/sal/sal/urls.py
