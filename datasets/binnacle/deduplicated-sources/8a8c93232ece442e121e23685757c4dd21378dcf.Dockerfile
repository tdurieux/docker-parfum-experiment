FROM python:2.7

ENV TERM=xterm

# docker build-time args
ARG SERVICE
ARG MAIN=main.py

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
  vim \
  less \
  nano \
  libicu-dev

RUN apt-get autoremove -y

COPY $SERVICE/requirements.txt .
RUN pip install --upgrade pip
RUN pip install -U git+https://github.com/aboSamoor/polyglot.git@master
RUN pip install --no-cache-dir -r requirements.txt

COPY $SERVICE .
# for now you need to have your models in the $SERVICE/models folder so they can be copied up...should add to trained models container?
COPY $SERVICE/models ./models/
# create consistent top-level filename
COPY $SERVICE/$MAIN main.py
# match project dir structure to satisfy imports
COPY util /usr/src/util

ENTRYPOINT ["python", "-u", "main.py", "-englishModel", "Aug09_en", "-arabicModel", "Aug09_ar", "-modelPath", "./models/"]
