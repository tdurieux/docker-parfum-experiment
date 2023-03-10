FROM debian:latest
MAINTAINER Alexandros Kosiaris <akosiaris@gmail.com>
EXPOSE 8000
RUN apt-get update && apt-get install --no-install-recommends -y \
	python-pip python-ldap && rm -rf /var/lib/apt/lists/*;
COPY . /srv/servermon
WORKDIR /srv/servermon
RUN pip install --no-cache-dir -r requirements.txt
RUN cp servermon/settings.py.dist servermon/settings.py
RUN python servermon/manage.py syncdb --noinput --settings=settings_test
RUN python servermon/manage.py migrate --noinput --settings=settings_test
RUN python servermon/manage.py loaddata --settings=settings_test vendor-model sampledata
CMD ["/usr/bin/python", "servermon/manage.py", "runserver", "--settings=settings_test", "--pythonpath=.", "0.0.0.0:8000"]
