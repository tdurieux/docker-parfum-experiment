#
# sphinx-app
#

FROM nginx:1.10
MAINTAINER KUBO Atsuhiro <kubo@iteman.jp>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y less vim-tiny && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Nginx
ENV APP_DOCUMENT_ROOT /var/app/_build/html
RUN rm -rf /usr/share/nginx/html

# Sphinx
RUN curl -fsSLk https://bootstrap.pypa.io/get-pip.py | python
RUN /usr/local/bin/pip install -U sphinx
RUN /usr/local/bin/pip install -U sphinx-intl

# Sphinx application
ADD app/init /usr/local/sbin/app-init
RUN chmod 755 /usr/local/sbin/app-init

# System
RUN dpkg-reconfigure -f noninteractive locales
ADD system/init /usr/local/sbin/system-init
RUN chmod 755 /usr/local/sbin/system-init
ADD system/locale.sh /usr/local/sbin/system-locale.sh
ADD system/timezone.sh /usr/local/sbin/system-timezone.sh

# Others
RUN mkdir /var/app
RUN echo "This file is a placeholder to expose /var/app directory after creating a new container from Kitematic." > /var/app/.placeholder
VOLUME ["/var/app"]

# Command
CMD ["/usr/local/sbin/system-init"]
