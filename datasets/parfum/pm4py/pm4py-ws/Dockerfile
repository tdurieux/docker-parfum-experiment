FROM tiangolo/uwsgi-nginx-flask

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nano vim git python3-pydot python-pydot python-pydot-ng graphviz python3-tk zip unzip curl ftp fail2ban python3-openssl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install nodejs

COPY ./docker-sec-confs/sysctl.conf /etc/sysctl.conf
COPY ./docker-sec-confs/limits.conf /etc/security/limits.conf
COPY ./docker-sec-confs/nginx.conf /etc/nginx/nginx.conf
#COPY ./docker-sec-confs/nginx_ssl.conf /etc/nginx/conf.d/nginx_ssl.conf
COPY ./docker-sec-confs/jail.local /etc/fail2ban/jail.local

RUN pip install --no-cache-dir -U pm4py==1.2.2 Flask flask-cors setuptools
RUN pip install --no-cache-dir -U pm4pycvxopt
#RUN pip install --no-cache-dir -U pm4pybpmn
COPY . /app
#RUN cd /app/files && python download_big_logs.py
RUN echo "enable_session = True" >> /app/pm4pywsconfiguration/configuration.py
RUN echo "static_folder = '/app/webapp2/dist'" >> /app/pm4pywsconfiguration/configuration.py
RUN echo "ssl_context_directory = '/app/ssl_cert_gen'" >> /app/pm4pywsconfiguration/configuration.py
RUN echo "log_manager_default_variant = 'multinode_file_based'" >> /app/pm4pywsconfiguration/configuration.py
#RUN pip install --no-cache-dir -U pyOpenSSL
#RUN cd /app/ssl_cert_gen && python create.py

RUN mkdir -p /app/webapp2
RUN rm -rRf /app/webapp2
RUN cd / && git clone https://github.com/pm-tk/source.git
RUN cd / && mv /source /app/webapp2
#RUN cd /app/webapp2 && npm install && npm install --save-dev --unsafe-perm node-sass && npm install -g @angular/core @angular/cli @angular/material
#RUN cd /app/webapp2 && ng build --prod

RUN cd /app/webapp2 && wget http://www.alessandroberti.it/dist.tar && tar xvf dist.tar

RUN cd /app && python setup.py install
