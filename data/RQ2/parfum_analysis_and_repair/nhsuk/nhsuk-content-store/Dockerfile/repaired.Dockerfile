FROM python:3.5.2

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN sed -i "s/httpredir.debian.org/$( curl -f -s -D - https://httpredir.debian.org/demo/debian/ | awk '/^Link:/ { print $2 }' | sed -e 's@<http://\(.*\)/debian/>;@\1@g')/" /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -yq \
        postgresql-client && rm -rf /var/lib/apt/lists/*;

ADD ./ .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD python manage.py runserver 0.0.0.0:8000
