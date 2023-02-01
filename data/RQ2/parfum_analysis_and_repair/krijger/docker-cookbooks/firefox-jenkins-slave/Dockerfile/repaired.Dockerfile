FROM quintenk/jenkins-slave

MAINTAINER Quinten Krijger "https://github.com/Krijger"

RUN apt-get -y --no-install-recommends install firefox xvfb && rm -rf /var/lib/apt/lists/*;
ADD xvfb.sv.conf /etc/supervisor/conf.d/
CMD supervisord -c /etc/supervisor.conf

