FROM python:3.9.0

WORKDIR /home/

RUN echo 'asadfasg'

RUN git clone https://github.com/noeul1114/gis_5ban_1.git

WORKDIR /home/gis_5ban_1/

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir gunicorn

RUN pip install --no-cache-dir mysqlclient

EXPOSE 8000

CMD ["bash", "-c", "python manage.py collectstatic --noinput --settings=gisweb_1.settings.deploy && python manage.py migrate --settings=gisweb_1.settings.deploy && gunicorn --env DJANGO_SETTINGS_MODULE=gisweb_1.settings.deploy gisweb_1.wsgi --bind 0.0.0.0:8000"]
