FROM python:2.7.16
ENV PYTHONUNBUFFERED 1

RUN set -ex
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt install --no-install-recommends -t jessie-backports openjdk-8-jre-headless ca-certificates-java -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -qq ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rubygems && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

RUN gem install --no-rdoc --no-ri rb-inotify -v 0.9.10 #fixed version of compass dependency
RUN gem install --no-rdoc --no-ri sass -v 3.4.22
RUN gem install --no-rdoc --no-ri compass -v 1.0.3

RUN mkdir /code

ADD requirements.txt /code/
ADD requirements/ /code/requirements/
ADD package.json /code/
WORKDIR /code

RUN pip install --no-cache-dir -r requirements.txt
RUN npm install && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;
