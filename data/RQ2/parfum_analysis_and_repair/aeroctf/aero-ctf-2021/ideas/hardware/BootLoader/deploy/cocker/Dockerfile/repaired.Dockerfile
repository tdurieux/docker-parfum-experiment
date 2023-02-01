FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -yyq
RUN apt-get install --no-install-recommends make -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends socat -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sudo -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends autoconf -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends minizip -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libminizip-dev -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libopenal1 libopenal-dev -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libz-dev -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends xdg-utils -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -yyq && rm -rf /var/lib/apt/lists/*;

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layout select 'English (US)' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layoutcode select 'us' | debconf-set-selections && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

RUN wget https://github.com/lcgamboa/picsimlab/releases/download/v0.8.6/PICSimLab_NOGUI-0.8.6-x86_64.AppImage
RUN wget https://github.com/lcgamboa/picsimlab/releases/download/v0.8.6/picsimlab_0.8.6_experimetal_Ubuntu_20.10_amd64.deb

RUN apt-get install --no-install-recommends gtkwave -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gpsim -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends cutecom -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gedit -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libwxbase3.0-0v5 -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libwxgtk3.0-gtk3-0v5 -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libarchive-tools -yyq && rm -rf /var/lib/apt/lists/*;
RUN dpkg -i picsimlab_0.8.6_experimetal_Ubuntu_20.10_amd64.deb

RUN chmod 700 ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage
RUN apt-get install --no-install-recommends supervisor -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -yyq && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyserial
RUN apt-get install --no-install-recommends net-tools -yyq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends netcat -yyq && rm -rf /var/lib/apt/lists/*;
ADD ./supervisor /supervisor
RUN ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage --appimage-extract
COPY ./listener.py /listener.py
COPY ./main.pzw /main.pzw
CMD ["supervisord","-c","/supervisor/service_script.conf"]

#RUN ./PICSimLab_NOGUI-0.8.6-x86_64.AppImage --appimage-extract && ./squashfs-root/AppRun 	 && rm -rf ./squashfs-root

#//socat /dev/ttyUSB0,b115200,raw,echo=0,crnl -
#sudo socat tcp-l:5760 /dev/ttyS21,raw,echo=0,b9600,fork system:echo "123"