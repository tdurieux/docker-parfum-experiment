FROM ansible/ansible-runner:1.3.2

# Install dependencies
RUN yum -y install bash wget unzip gcc \
           python-devel python-setuptools \
           nginx supervisor && rm -rf /var/cache/yum

RUN pip install --no-cache-dir cryptography PyYAML netaddr notario \
    pyOpenSSL flask flask-restful uwsgi && \
    rm -rf /var/cache/yum

# Prepare folders for shared access and ssh
RUN mkdir -p /etc/ansible-runner-service && \
    mkdir -p /root/.ssh && \
    mkdir -p /usr/share/ansible-runner-service/{artifacts,env,project,inventory,client_cert}

# Install Ansible Runner Service
WORKDIR /root
COPY ./*.py ansible-runner-service/
COPY ./*.yaml ansible-runner-service/
COPY ./runner_service ansible-runner-service/runner_service
COPY ./samples ansible-runner-service/samples

# Put configuration files in the right places
# Nginx configuration
COPY misc/nginx/nginx.conf /etc/nginx/
# Ansible Runner Service nginx virtual server
COPY misc/nginx/ars_site_nginx.conf /etc/nginx/conf.d
# Ansible Runner Service uwsgi settings
COPY misc/nginx/uwsgi.ini /root/ansible-runner-service
# Supervisor start sequence
COPY misc/nginx/supervisord.conf /root/ansible-runner-service

# Start services
CMD ["/usr/bin/supervisord", "-c", "/root/ansible-runner-service/supervisord.conf"]
