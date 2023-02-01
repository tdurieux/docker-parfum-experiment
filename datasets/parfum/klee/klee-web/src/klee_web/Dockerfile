FROM python:3.8-buster

# Install Node.js, Ruby and other frontend tools
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y ruby-full nodejs
RUN npm install -g bower grunt-cli
RUN gem install sass

COPY ./requirements.txt /
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

WORKDIR /kleeweb
COPY . /kleeweb

RUN DEVELOPMENT=1 ./build.sh
RUN ln -s /kleeweb/frontend/static /static

# For nginx static content
# TODO: Is there a way to avoid the symlink?
VOLUME /static/
# For nginx to uWSGI's socket
# TODO: The following doesn't work, we have to manually export the socket
# VOLUME /tmp

CMD ./run.sh
