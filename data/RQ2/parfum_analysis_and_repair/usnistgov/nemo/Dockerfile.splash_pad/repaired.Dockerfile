FROM python:3.7

COPY . /nemo/
RUN pip install --no-cache-dir /nemo/
RUN rm --recursive --force /nemo

RUN mkdir /nemo
RUN mkdir /nemo/media
RUN mkdir /nemo/media/tool_images
WORKDIR /nemo

COPY resources/icons/* /nemo/media/
COPY resources/people/* /nemo/media/
COPY resources/sounds/* /nemo/media/
COPY resources/images/tool_images/* /nemo/media/tool_images/
COPY resources/images/* /nemo/media/
COPY resources/emails/* /nemo/media/
COPY resources/splash_pad_rates.json /nemo/media/rates.json
COPY resources/splash_pad_settings.py /nemo/
COPY resources/fixtures/splash_pad.json /nemo/

ENV DJANGO_SETTINGS_MODULE "splash_pad_settings"
ENV PYTHONPATH "/nemo/"

RUN django-admin makemigrations NEMO
RUN django-admin migrate
RUN django-admin loaddata splash_pad.json

ENV REMOTE_USER "captain"
EXPOSE 8000/tcp
CMD ["django-admin","runserver","0.0.0.0:8000"]