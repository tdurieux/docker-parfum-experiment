FROM python:3.6

COPY . /nemo/
RUN pip install /nemo/
RUN rm --recursive --force /nemo

RUN mkdir /nemo
RUN mkdir /nemo/media
WORKDIR /nemo

COPY resources/icons/* /nemo/media/
COPY resources/people/* /nemo/media/
COPY resources/splash_pad_settings.py /nemo/
COPY NEMO/fixtures/splash_pad.json /nemo/

ENV DJANGO_SETTINGS_MODULE "splash_pad_settings"
ENV PYTHONPATH "/nemo/"

RUN django-admin makemigrations NEMO
RUN django-admin migrate
RUN django-admin loaddata splash_pad.json

ENV REMOTE_USER "captain"
EXPOSE 8000/tcp
CMD ["django-admin","runserver","0.0.0.0:8000"]