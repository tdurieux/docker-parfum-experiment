FROM tffunck/appian:base
MAINTAINER Thomas Funck <t.funck@juelich-fz.de>

RUN pip3 install --no-cache-dir --user pint
#APPIAN
RUN cd /opt/APPIAN && git fetch --all && git reset --hard origin/master



