# docker build -t warper:latest -f Dockerfile-warper .

FROM ubuntu:18.04

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential git curl file \
  ruby-dev nodejs libpq-dev postgresql-client ruby-mapscript \
  zlib1g-dev liblzma-dev imagemagick gdal-bin gnupg \
  python-pip python-setuptools \
  logrotate nginx-full gettext-base && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pillow modestmaps google-cloud-storage

## install gcsfuse for use mounting cloud storage
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-bionic main" | tee /etc/apt/sources.list.d/gcsfuse.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update -qq && apt-get install --no-install-recommends -y gcsfuse && rm -rf /var/lib/apt/lists/*;

#for 18.04 we need to loosen up the imagemagick policy limits
COPY ./warper/config/imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

#copy log rotate
COPY ./warper/config/mapwarper.logrotate /etc/logrotate.d/warper
RUN chmod 0644 /etc/logrotate.d/warper

RUN mkdir -p /app

WORKDIR /app

COPY ./warper/Gemfile  Gemfile
COPY ./warper/Gemfile.lock Gemfile.lock
RUN echo "gem: --no-document" >> ~/.gemrc

RUN gem install bundler -v=1.17.3

RUN gem install bundle
RUN gem update --system && rm -rf /root/.gem;
RUN bundle update --bundler
RUN bundle install

COPY ./warper .

RUN bash ./lib/cloudbuild/copy_configs.sh

RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=dummytokenforbuild

ENTRYPOINT ["nginx", "-g", "daemon off;"]
