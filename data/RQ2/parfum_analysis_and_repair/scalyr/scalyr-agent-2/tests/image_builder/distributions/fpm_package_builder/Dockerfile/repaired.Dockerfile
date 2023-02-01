FROM python:3.6 as fpm_package_build

RUN apt update && apt install --no-install-recommends -y ruby ruby-dev rubygems rpm build-essential && rm -rf /var/lib/apt/lists/*;

RUN gem install --no-document fpm