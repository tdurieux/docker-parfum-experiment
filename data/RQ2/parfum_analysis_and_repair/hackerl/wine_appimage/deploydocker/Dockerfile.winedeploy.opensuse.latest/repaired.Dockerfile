FROM opensuse/tumbleweed

COPY . /srv/wineappimage

WORKDIR /srv/wineappimage
RUN /srv/wineappimage/deployscript/opensuse-winedeploy.sh