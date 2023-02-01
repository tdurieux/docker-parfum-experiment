FROM brucepc/mapguide

ENV DEBIAN_FRONTEND noninteractive

# ---------
# MULTIVERSE
# ---------
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common wget unzip curl && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository multiverse
RUN apt-get update

# ---------
# MS CORE FONTS
# ---------
# from http://askubuntu.com/a/25614
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer && rm -rf /var/lib/apt/lists/*;
# ADD localfonts.conf /etc/fonts/local.conf
# RUN fc-cache -f -v

RUN wget https://github.com/jumpinjackie/mapguide-react-layout/releases/download/v0.13.1/viewer.zip -O /tmp/viewer.zip
RUN wget https://download.osgeo.org/mapguide/releases/3.0.0/extras/Sheboygan.mgp -O /usr/local/mapguideopensource-3.1.2/server/Packages/Sheboygan.mgp
RUN unzip /tmp/viewer.zip -d /usr/local/mapguideopensource-3.1.2/webserverextensions/www
ADD index.php /usr/local/mapguideopensource-3.1.2/webserverextensions/www