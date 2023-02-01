FROM python:3.5
ENV PATH /usr/local/bin:$PATH
ADD . /code
WORKDIR /code
RUN pip3 install --no-cache-dir -r requirements.txt
CMD scrapy crawl quotes
