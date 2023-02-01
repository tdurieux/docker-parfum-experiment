FROM python:3.6

ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements.txt /requirements.txt


RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir scrypt
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir steem
RUN pip install --no-cache-dir -r /requirements.txt

RUN apt-get install --no-install-recommends -y ruby-dev rubygems && rm -rf /var/lib/apt/lists/*;
RUN gem install sass

COPY ./compose/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./compose/django/start-dev.sh /start-dev.sh
RUN sed -i 's/\r//' /start-dev.sh
RUN chmod +x /start-dev.sh

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
