FROM python:3.4

WORKDIR /app

RUN apt-get install --no-install-recommends -y libjpeg62-turbo-dev libfreetype6 libfreetype6-dev && rm -rf /var/lib/apt/lists/*;

COPY . /app

RUN pip install --no-cache-dir -r ./requirements/development.txt
RUN pip install --no-cache-dir -r ./requirements/production.txt

CMD python manage.py runserver
