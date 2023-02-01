FROM owasp/zap2docker-weekly
MAINTAINER Matt Konda <mkonda@jemurai.com>
RUN apt-get install -y --no-install-recommends python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade git+https://github.com/Grunny/zap-cli.git
RUN chown -R zap /zap/
ENV ZAP_PORT 8080
