FROM ubuntu:22.04
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install wget python3-dev git python3-venv python3-pip python-is-python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential tcl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libreoffice-base-nogui libreoffice-calc-nogui libreoffice-draw-nogui libreoffice-impress-nogui libreoffice-math-nogui libreoffice-writer-nogui && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install exiftool && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unrar && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxml2-dev libxslt1-dev antiword unrtf poppler-utils pstotext tesseract-ocr flac ffmpeg lame libmad0 libsox-fmt-mp3 sox libjpeg-dev swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apparmor-utils && rm -rf /var/lib/apt/lists/*;

RUN sed '/^profile libreoffice-soffice \/usr\/lib\/libreoffice\/program\/soffice.bin/a owner @{HOME}\/pandora\/tasks\/\*\* rwk,/' /etc/apparmor.d/usr.lib.libreoffice.program.soffice.bin -i

RUN pip3 install --no-cache-dir poetry

WORKDIR pandora

COPY pandora pandora/
COPY tools tools/
COPY bin bin/
COPY doc doc/
COPY website website/
COPY pyproject.toml .
COPY poetry.lock .
COPY README.md .
COPY LICENSE .

RUN mkdir cache storage tasks
RUN echo PANDORA_HOME="`pwd`" >> .env
RUN poetry install
RUN poetry run tools/3rdparty.py
