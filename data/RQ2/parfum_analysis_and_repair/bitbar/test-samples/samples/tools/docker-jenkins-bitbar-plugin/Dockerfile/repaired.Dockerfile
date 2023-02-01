FROM jenkins/jenkins:lts
RUN /usr/local/bin/install-plugins.sh testdroid-run-in-cloud
USER root
RUN apt-get update && apt-get install --no-install-recommends -y python-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir testdroid
EXPOSE 8080
USER jenkins