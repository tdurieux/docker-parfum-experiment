FROM ubuntu:trusty
RUN apt-get update && apt-get upgrade -y
RUN apt-get \
  -o Acquire::BrokenProxy="true" --no-install-recommends \
  -o Acquire::http::No-Cache="tr \
  -o Acquire::http::Pipeline-Dep \
  install -y sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get \
  -o Acquire::BrokenProxy="true" --no-install-recommends \
  -o Acquire::http::No-Cache="tr \
  -o Acquire::http::Pipeline-Dep \
  install -y \
  gcc g++ make python python-dev python-virtualenv \
  libjpeg-dev libz-dev libfreetype6-dev liblcms-dev \
  libxml2-dev libxslt-dev \
  ocaml-nox git-core \
  python-imaging python-lxml \
  texlive-latex-recommended ploticus dvipng imagemagick \
  pdftk && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -i http://pypi.pediapress.com/simple/ mwlib mwlib.rl
RUN useradd -m mwuser && echo "mwuser:mwuser" | chpasswd && adduser mwuser sudo
RUN mkdir -p /data/mwcache && chown -R mwuser:mwuser /data/
USER mwuser
WORKDIR /home/mwuser

CMD nserve & mw-qserve & nslave --cachedir /data/mwcache