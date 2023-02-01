FROM python:3.10.2
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs netcat p7zip-full && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/openfda
ADD . ./
RUN rm -rf .eggs _python-env openfda.egg-info logs
RUN ./bootstrap.sh
CMD ["./scripts/all-pipelines-docker.sh"]
