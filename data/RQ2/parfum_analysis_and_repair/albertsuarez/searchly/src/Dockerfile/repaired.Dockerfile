FROM python:3.7
ADD . /srv/searchly
WORKDIR /srv/searchly
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.lock
RUN python3 -m nltk.downloader stopwords
CMD uwsgi --ini src/searchly.ini