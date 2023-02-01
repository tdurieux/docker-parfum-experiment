FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip wget git && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/virtix/clouseau/archive/master.tar.gz

RUN tar xfz master.tar.gz && rm master.tar.gz

RUN pip install --no-cache-dir -r /clouseau-master/requirements.txt

ENV PYTHONPATH $PYTHONPATH:/clouseau-master

CMD /clouseau-master/bin/clouseau_thin -u $GIT_URL
