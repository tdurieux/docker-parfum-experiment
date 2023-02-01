FROM python:3.7-buster
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN apt-get -qq update
RUN apt-get install --no-install-recommends -yq ffmpeg tesseract-ocr apt-transport-https libnss3 xvfb && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -e git+https://github.com/PsychoinformaticsLab/pliers.git#egg=pliers
RUN pip install --no-cache-dir clarifai duecredit google-api-python-client IndicoIo librosa >=0.6.3 pysrt pytesseract spacy rev_ai

RUN wget -O- https://neuro.debian.net/lists/buster.us-nh.libre | tee /etc/apt/sources.list.d/neurodebian.sources.list && apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com 0xA5D32F012649A5A9
RUN apt-get update && apt-get install --no-install-recommends -yq datalad && pip install --no-cache-dir datalad && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_12.x buster main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_12.x buster main" | tee -a /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

COPY requirements.txt /usr/src/app/
COPY optional_requirements.txt /usr/src/app
RUN pip install --no-cache-dir setuptools==45
RUN pip uninstall -y enum34
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r optional_requirements.txt
RUN python -m pliers.support.download
RUN python -m pliers.support.setup_yamnet

COPY . /usr/src/app

RUN git config --global user.name "Neuroscout"
RUN git config --global  user.email "delavega@utexas.edu"

RUN crontab /usr/src/app/update.txt
RUN service cron start

WORKDIR /neuroscout
