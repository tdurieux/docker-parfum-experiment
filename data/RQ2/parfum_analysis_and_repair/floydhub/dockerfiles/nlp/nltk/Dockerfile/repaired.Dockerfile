FROM floydhub/python-base:3.6
MAINTAINER Floyd Labs "support@floydhub.com"

RUN pip install --no-cache-dir -U nltk
RUN python -m nltk.downloader -q all
RUN pip install --no-cache-dir -U numpy
