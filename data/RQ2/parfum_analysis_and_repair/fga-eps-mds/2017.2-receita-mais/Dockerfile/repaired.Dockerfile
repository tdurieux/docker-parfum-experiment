FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code

ADD requirements.txt /code/
ADD requirements-dev.txt /code/
ADD gulpfile.js /code/
ADD package.json /code/

RUN apt-get update -y && \
    apt-get install --no-install-recommends gettext -y && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends npm -y && \
    apt-get install -y --no-install-recommends nodejs-legacy && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

ADD . /code/

RUN npm install && npm cache clean --force;
