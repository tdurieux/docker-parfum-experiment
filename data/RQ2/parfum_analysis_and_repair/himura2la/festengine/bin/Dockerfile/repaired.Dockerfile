FROM debian:10
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -y gettext python3 python3-pip vlc libjpeg-dev zlib1g-dev \
 && pip3 install --no-cache-dir -U \
    -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/debian-10 \
    wxPython \
 && pip3 install --no-cache-dir -U pyinstaller python-vlc && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . .
WORKDIR /app/bin
RUN python3 ./build.py -novlc \
 && mv ./install.sh ./FestEngine/ \
 && mkdir -p ./FestEngine/locale/ru/LC_MESSAGES \
 && msgfmt -o ./FestEngine/locale/ru/LC_MESSAGES/main.mo \
           ../src/locale/ru/LC_MESSAGES/main.po
RUN tar -zcvf fest_engine.tar.gz FestEngine && rm fest_engine.tar.gz