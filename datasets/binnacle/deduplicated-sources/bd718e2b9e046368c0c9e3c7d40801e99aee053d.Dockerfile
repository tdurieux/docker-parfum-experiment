# Build PostgreSQL 9.5 image listening on static port 5432
#
# IMAGE USAGE:
#   detached:
#     docker run -d -p <hostport>:5432 <imagename>
#   interactive:
#     docker run -it -p <hostport>:5432 <imagename> "powershell /install/start"
#
# For ideas on volume mapping with PostgreSQL, see these notes from the 
# linux Dockerfile implementation:
#   https://docs.docker.com/engine/examples/postgresql_service/

FROM windowsservercore:10.0.14300.1000

# maintainer for image metadata
MAINTAINER Buc Rogers

ENV PGDATA c:\\sql
ENV PGPORT 5432
#not using PGUSER here due to need to run createuser downstream to create role
ENV PGUSERVAR postgres
ENV PGDOWNLOADVER postgresql-9.5.2-1-windows-x64-binaries.zip

# download and extract binaries
RUN powershell wget http://get.enterprisedb.com/postgresql/%PGDOWNLOADVER% \
  -outfile %PGDOWNLOADVER%

RUN powershell expand-archive %PGDOWNLOADVER% \
  -force -destinationpath /postgresql

# reduce image size by removing download zip
RUN del %PGDOWNLOADVER%

#install VC 2013 runtime required by postgresql
#use chocolatey pkg mgr to facilitate command-line installations
RUN @powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
RUN choco install vcredist2013 -y

# copy dependent script(s)
COPY . /install

WORKDIR /postgresql/pgsql/bin

# init postgresql db cluster, config and create and start service
RUN powershell /install/init-config-start-service %PGDATA% %PGUSERVAR%

# start postgreSQL using the designated data dir
CMD powershell /install/start detached %PGDATA% %PGUSERVAR%
