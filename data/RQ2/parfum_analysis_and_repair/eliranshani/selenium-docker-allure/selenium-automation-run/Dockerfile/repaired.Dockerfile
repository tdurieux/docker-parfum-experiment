FROM blazemeter/selenium_base:latest

# pip
COPY blazedemo_app/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN easy_install -U setuptools
RUN pip install --no-cache-dir pytest-dependency

# Dokcer entry
COPY blazedemo_app/docker-entry.sh .
ENTRYPOINT ["/docker-entry.sh"]

CMD ["/bin/true"]
