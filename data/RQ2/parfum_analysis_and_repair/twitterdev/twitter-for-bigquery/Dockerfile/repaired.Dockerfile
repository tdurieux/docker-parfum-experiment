FROM google/python

RUN apt-get install --no-install-recommends -y libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir config
RUN pip install --no-cache-dir tweepy
RUN pip install --no-cache-dir bigquery-python
RUN pip install --no-cache-dir --upgrade google-api-python-client

ADD config /config
ADD schema /schema
ADD key.p12 /key.p12
ADD logging.conf /logging.conf
ADD libs /libs
ADD utils.py /utils.py
ADD load.py /load.py

CMD python load.py
