FROM ubuntu:16.04  
  
# install chaperone  
RUN set -x \  
&& apt-get update \  
&& apt-get install -y --no-install-recommends \  
python3 python3-pip python3-setuptools \  
&& pip3 install chaperone \  
&& mkdir /etc/chaperone.d  
  
# install the dependencies we need for scrapy + scrapyd  
RUN set -x \  
&& apt-get update \  
&& apt-get install -y --no-install-recommends \  
python3 python3-dev python3-pip python3-setuptools \  
libssl-dev libxml2-dev libxslt-dev libffi-dev \  
build-essential  
  
# install scrapyd  
ADD requirements.txt /  
RUN pip3 install -r requirements.txt  
  
# remove the stuff we dont need to keep around  
RUN apt-get remove -y \  
python-dev \  
libssl-dev libxml2-dev libxslt-dev libffi-dev \  
build-essential  
  
# install nginx and apache2-utils for htpasswd  
RUN apt-get update && apt-get install --no-install-recommends -y \  
nginx apache2-utils  
  
VOLUME /scrapyd  
  
RUN pip3 install --upgrade pip  
  
ADD scrapyd.conf /etc/scrapyd/scrapyd.conf  
ADD nginx.conf /etc/nginx/sites-enabled/default  
ADD chaperone.conf /etc/chaperone.d/chaperone.conf  
  
EXPOSE 6800  
  
ENTRYPOINT ["/usr/local/bin/chaperone"]  

