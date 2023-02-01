FROM heroku/cedar:14

# ignore errors now that some of the repos are not found (404)
RUN apt-get update; exit 0
RUN apt-get -y install jq python-pip wkhtmltopdf pdftk xvfb
RUN pip install -U pip setuptools
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb

# I don't yet know why this is needed. Install pyOpenSSL
# from setup.py fails with: No package 'libffi' found
# but works here.
RUN pip install pyOpenSSL
RUN pip install virtualenv
RUN gem install foreman

# Port is always 4000 for no good reason.
ENV PORT 4000
EXPOSE 4000
EXPOSE 22
ENTRYPOINT ["/usr/bin/dumb-init", "--", "gigalixir_run"]

RUN mkdir -p /app
RUN sed -i 's$root:x:0:0:root:/root:/bin/bash$root:x:0:0:root:/app:/bin/bash$' /etc/passwd
RUN mkdir -p /opt/gigalixir
RUN mkdir -p /release-config
RUN virtualenv /tmp/gigalixir
RUN chmod og+x /tmp/gigalixir/bin/activate
COPY etc/ssh/sshd_config /etc/ssh/sshd_config
COPY bashrc /app/.bashrc
RUN cp /root/.profile /app/.profile
ADD . /opt/gigalixir
WORKDIR /opt/gigalixir

RUN python setup.py install
WORKDIR /app


