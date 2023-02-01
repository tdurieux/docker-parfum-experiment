# start from base
FROM ubuntu:18.04

LABEL maintainer="Prakhar Srivastav <prakhar@prakhar.me>"

# install system-wide deps for python and node
RUN apt-get -yqq update
RUN apt-get -yqq --no-install-recommends install python3-pip python3-dev curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install --no-install-recommends -yq nodejs && rm -rf /var/lib/apt/lists/*;

# copy our application code
ADD flask-app /opt/flask-app
WORKDIR /opt/flask-app

# fetch app specific deps
RUN npm install && npm cache clean --force;
RUN npm run build
RUN pip3 install --no-cache-dir -r requirements.txt

# expose port
EXPOSE 5000

# start app
CMD [ "python3", "./app.py" ]
