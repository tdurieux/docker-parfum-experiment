FROM python:3.5.4  
RUN apt-get update && apt-get install -y --no-install-recommends \  
libldap2-dev \  
libsasl2-dev \  
python-pip \  
&& rm -rf /var/lib/apt/lists/* \  
&& pip install uwsgi==2.0.15  
  
ENV DJANGO_SETTINGS_MODULE timed.settings  
ENV STATIC_ROOT /var/www/static  
ENV UWSGI_INI /app/uwsgi.ini  
  
COPY . /app  
WORKDIR /app  
  
RUN make install  
  
RUN mkdir -p /var/www/static \  
&& ENV=docker ./manage.py collectstatic --noinput  
  
EXPOSE 80  
CMD ["uwsgi"]  

