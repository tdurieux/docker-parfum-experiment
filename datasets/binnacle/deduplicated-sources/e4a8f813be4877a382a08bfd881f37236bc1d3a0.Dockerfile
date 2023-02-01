FROM python:3.6

# Intall NEMO (in the current directory) and Gunicorn
COPY . /nemo/
RUN pip install /nemo/ gunicorn==19.9.0
RUN rm --recursive --force /nemo/

RUN mkdir /nemo
WORKDIR /nemo
ENV DJANGO_SETTINGS_MODULE "settings"
ENV PYTHONPATH "/nemo/"
COPY gunicorn_configuration.py /etc/

EXPOSE 8000/tcp

COPY start_NEMO_in_Docker.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start_NEMO_in_Docker.sh
CMD ["start_NEMO_in_Docker.sh"]
