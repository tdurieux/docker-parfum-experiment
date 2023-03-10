FROM jjanzic/docker-python3-opencv

RUN apt-get update \
&& apt-get install --no-install-recommends -y \
wget \
curl \
git \
unzip \
cmake \
build-essential \
mesa-utils \
apt-transport-https ca-certificates \
python3-pip \
pkg-config \
python-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y default-jre \
default-jdk && rm -rf /var/lib/apt/lists/*;

# Create backend directory
RUN mkdir /backend
COPY . /backend

RUN pip3 install --no-cache-dir -r "/backend/requirements.txt"
RUN pip3 install --no-cache-dir "/backend/en_core_web_sm-2.0.0.tar.gz"

WORKDIR /backend/corenlp
RUN wget https://nlp.stanford.edu/software/stanford-corenlp-full-2018-02-27.zip
RUN unzip stanford-corenlp-full-2018-02-27.zip
RUN pip3 install --no-cache-dir stanfordcorenlp

# setting environment variables
ENV GOOGLE_APPLICATION_CREDENTIALS="/backend/.gcloud_key.json"
ENV LEXIGRAM_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdSI6Imx4ZzphcGkiLCJzYyI6WyJrZzpyZWFkIiwiZXh0cmFjdGlvbjpyZWFkIl0sImFpIjoiYXBpOjcxMjIwZjAwLTkxMjAtMWZlMC0xYTJkLTk2MWJlOGNkM2Y2MSIsInVpIjoidXNlcjoxNWJlOGE5Yy0zZDAzLTJmNmMtZjkzMS04NjE5Yjk0YzhiOGMiLCJpYXQiOjE1MjIzMDk5MDd9.FxTChifr8ARvp55Xb8Gf1odMZKfrUPueEcmOGL0Fsn8"

CMD ["python3","/backend/app.py"]
