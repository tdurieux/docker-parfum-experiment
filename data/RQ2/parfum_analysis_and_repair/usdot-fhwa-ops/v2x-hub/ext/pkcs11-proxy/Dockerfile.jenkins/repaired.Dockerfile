FROM docker.sunet.se/jenkins-job
RUN apt-get install --no-install-recommends -y libssl-dev libseccomp-dev && rm -rf /var/lib/apt/lists/*;
