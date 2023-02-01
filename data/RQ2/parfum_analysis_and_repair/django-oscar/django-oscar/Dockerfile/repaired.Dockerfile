FROM python:3.8
ENV PYTHONUNBUFFERED 1

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt

RUN groupadd -r django && useradd -r -g django django
COPY . /app
RUN chown -R django /app

WORKDIR /app

RUN make install

USER django

RUN make build_sandbox

RUN cp --remove-destination /app/src/oscar/static/oscar/img/image_not_found.jpg /app/sandbox/public/media/

WORKDIR /app/sandbox/
CMD uwsgi --ini uwsgi.ini
