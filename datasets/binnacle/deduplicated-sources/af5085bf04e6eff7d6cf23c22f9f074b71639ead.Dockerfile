FROM python:3

#
# Dev-version adds ssh-server for Pycharm's remote interpretier feature
#   You should have ~/.ssh/id_rsa.pub public key to access container by ssh
#
#

# Prepare os libs
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    python-dev python-setuptools python-pip \
    git-core \
    openssh-server
RUN apt-get autoremove -y

# upgrade pip
RUN pip install --upgrade pip

# Prepare app specific modules
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

# Prepare app-dev specific modules
COPY requirements-dev.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

# Prepare initial
COPY deploy/django/entrypoint.sh /bin/entrypoint.sh
RUN chmod 700 /bin/entrypoint.sh

# Prepare dir for sshd
RUN mkdir -p /var/run/sshd

# Prepare key-based login to ssd (by copying local ~/.ssh/id_rsa.pub in ./dc.sh script)
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
COPY ./deploy/django/id_rsa.pub /root/.ssh/authorized_keys
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Static and media dir to expose out container onto nginx-service
RUN mkdir -p /static /media
ENV DJANGO_STATIC_ROOT="/static"
ENV DJANGO_MEDIA_ROOT="/media"

# Prepare user
RUN useradd -u 33 www-data | true
RUN chown -R www-data /media

# Prepare code dir
RUN mkdir -p /code
ENV PYTHONPATH="${PYTHONPATH}:/code"
WORKDIR /code

# Prepare ports
# django
EXPOSE 8000
# ssh
EXPOSE 22

ENTRYPOINT ["/bin/entrypoint.sh"]
