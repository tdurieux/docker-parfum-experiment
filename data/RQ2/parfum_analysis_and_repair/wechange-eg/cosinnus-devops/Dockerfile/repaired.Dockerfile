FROM python:3.6.7
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y libgeos-dev binutils libproj-dev gdal-bin && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && \
      npm i -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
WORKDIR /code

ADD . /code/
COPY ./docker-entrypoint.sh /
COPY devops/settings_docker.py /code/devops/settings.py
RUN pip install --no-cache-dir --ignore-installed --disable-pip-version-check pip setuptools wheel \
        && \
    hash pip \
        && \
    pip install --no-cache-dir -r /code/requirements_docker.txt

RUN /code/local_setup.sh
WORKDIR /code/cosinnus-core
RUN npm i --production && npm run production && npm cache clean --force;
WORKDIR /code
CMD ["/docker-entrypoint.sh"]
