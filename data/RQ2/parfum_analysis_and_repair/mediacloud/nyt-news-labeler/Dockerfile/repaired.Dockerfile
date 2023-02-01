FROM ubuntu:20.04

MAINTAINER Rahul Bhargava <r.bhargava@northeastern.edu>

ARG DEBIAN_FRONTEND=noninteractive

COPY . /nyt-news-labeler/

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y brotli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;
WORKDIR /nyt-news-labeler/

RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
RUN python3.7 -m pip install -r requirements.txt
RUN python3.7 -m nltk.downloader -d /usr/local/share/nltk_data punkt
RUN python3.7 download_models.py

EXPOSE 8000

CMD [ "/usr/local/bin/gunicorn", "-b", ":8000", "-t", "900", "app:app" ]
