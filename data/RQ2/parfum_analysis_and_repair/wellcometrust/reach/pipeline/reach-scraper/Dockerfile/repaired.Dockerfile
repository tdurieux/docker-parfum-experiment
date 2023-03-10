FROM reach.base

WORKDIR /opt/reach

COPY ./requirements.txt /opt/reach/requirements.scraper.txt

RUN pip install --no-cache-dir -U pip && \
        python3 -m pip install -r /opt/reach/requirements.scraper.txt


COPY ./scrapy.cfg /etc/reach/scrapy.cfg
COPY ./spider_task.py /opt/reach/spider_task.py
COPY ./wsf_scraping /opt/reach/wsf_scraping

# Give execution rights to the entrypoint Python script
RUN chmod +x /opt/reach/spider_task.py

ENTRYPOINT ["/opt/reach/spider_task.py"]
