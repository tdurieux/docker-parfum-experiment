FROM opensuse/leap:15.1

MAINTAINER Tobias Megies

RUN zypper --non-interactive addrepo http://download.opensuse.org/repositories/Application:/Geo/openSUSE_Leap_15.1/Application:Geo.repo
RUN zypper --non-interactive --no-gpg-checks refresh
RUN zypper --non-interactive update
RUN zypper --non-interactive install gcc python-devel python-numpy python-scipy python-matplotlib python-SQLAlchemy python-lxml python-mock python-pip python-tornado python-requests python-decorator python-basemap python-basemap-data python-nose python-pyshp
RUN zypper --non-interactive install python-future
RUN pip install --no-cache-dir https://github.com/Damgaard/PyImgur/archive/9ebd8bed9b3d0ae2797950876f5c1e64a560f7d8.zip
RUN zypper --non-interactive install ca-certificates-mozilla
