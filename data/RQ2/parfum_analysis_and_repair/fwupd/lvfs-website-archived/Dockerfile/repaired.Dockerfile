FROM centos:8
EXPOSE 5000

RUN dnf install -y epel-release dnf-plugins-core
RUN dnf config-manager --set-enabled PowerTools epel
RUN dnf -y copr enable rhughes/lvfs-website
RUN dnf -y install \
	bsdtar \
	cairo-gobject-devel \
	clamav \
	clamav-update \
	clamd \
	fdupes \
	git \
	gnutls-utils \
	gobject-introspection-devel \
	libgcab1 \
	logrotate \
	python3-devel \
	python3-pip \
	python3-psutil \
	UEFITool \
	s3cmd \
	sudo

# create all our dirs
RUN bash -c 'mkdir -p /app/{scripts,conf,logs/uwsgi}'
RUN mkdir /data /backups
RUN usermod -a -G virusgroup nobody
RUN chmod g+rx /var/run/clamd.scan
WORKDIR /app

# create and activate a venv
ENV VIRTUAL_ENV=/app/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install all the things
COPY requirements.txt /app/conf
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r conf/requirements.txt
RUN pip3 install --no-cache-dir uwsgi

# copy the app; various configs and scripts
COPY lvfs/ /app/lvfs/
COPY cabarchive/ /app/cabarchive/
COPY pkgversion/ /app/pkgversion/
COPY jcat/ /app/jcat/
COPY infparser/ /app/infparser/
COPY plugins/ /app/plugins/
COPY migrations/ /app/migrations/
COPY docker/files/application/uwsgi.ini /app/conf/uwsgi.ini
COPY docker/files/application/flaskapp.cfg /app/lvfs/flaskapp.cfg
COPY docker/files/application/scan.conf /etc/clamd.d/scan.conf
COPY docker/files/lvfs-entrypoint.sh /app/lvfs-entrypoint.sh

RUN chown -R 65534:65534 /app /data /backups

ENTRYPOINT [ "./lvfs-entrypoint.sh" ]
