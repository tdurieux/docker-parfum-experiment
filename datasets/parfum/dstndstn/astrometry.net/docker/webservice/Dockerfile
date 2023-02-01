FROM astrometrynet/solver:latest

RUN pip3 install --no-cache-dir Django

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && \
    apt install -y --no-install-recommends \
    apache2 \
    libapache2-mod-wsgi-py3 \
    less \
    emacs-nox

RUN pip3 install --no-cache-dir \
    social-auth-core django-social-auth3 social-auth-app-django

WORKDIR /src/astrometry/net

RUN ln -s settings_test.py settings.py

# Yuck!  The installed 'astrometry' package conflicts with '.', so paste it in...
RUN rm -R /usr/local/lib/python/astrometry/net && \
    ln -s /src/astrometry/net /usr/local/lib/python/astrometry/net

RUN mkdir appsecrets && \
    touch appsecrets/__init__.py && \
    touch appsecrets/auth.py
COPY django_db.py /src/astrometry/net/appsecrets/

RUN git stash && git pull

RUN mv migrations/* /tmp && \
    python manage.py makemigrations && \
    python manage.py migrate && \
    python manage.py makemigrations net && \
    python manage.py migrate net && \
    python manage.py loaddata fixtures/initial_data.json && \
    python manage.py loaddata fixtures/flags.json

CMD python manage.py runserver

EXPOSE 8000
