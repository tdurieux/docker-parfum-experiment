FROM queeno/ubuntu-desktop
MAINTAINER Peter Q <me@peterq.cn>

RUN sed -i 's#http://archive.ubuntu.com/#http://cn.archive.ubuntu.com/#' /etc/apt/sources.list;

RUN apt-get update && apt-get install --no-install-recommends -y libqt5multimedia5-plugins && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/pan-light

COPY root.pan-light/ /root/pan-light/

RUN sh /root/pan-light/fix-file.sh

CMD /root/pan-light/demo_instance_manager.sh
