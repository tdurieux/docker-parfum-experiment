FROM ehco1996/django-sspanel:runtime as runtime

WORKDIR /src/django-sspanel

COPY . /src/django-sspanel

CMD ["uwsgi", "uwsgi.ini"]