FROM opendronemap/odm:gpu
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000

USER root
RUN apt-get update && apt-get install --no-install-recommends -y curl gpg-agent ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs unzip p7zip-full && npm install -g nodemon && \
    ln -s /code/SuperBuild/install/bin/untwine /usr/bin/untwine && \
    ln -s /code/SuperBuild/install/bin/entwine /usr/bin/entwine && \
    ln -s /code/SuperBuild/install/bin/pdal /usr/bin/pdal && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;


RUN mkdir /var/www

WORKDIR "/var/www"
RUN useradd -m -d "/home/odm" -s /bin/bash odm
COPY --chown=odm:odm . /var/www

RUN npm install --production && mkdir -p tmp && npm cache clean --force;

RUN chown -R odm:odm /var/www
RUN chown -R odm:odm /code

USER odm

ENTRYPOINT ["/usr/bin/node", "/var/www/index.js"]
