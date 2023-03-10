FROM python:3.6
MAINTAINER John Readey <jreadey@hdfgroup.org>
RUN cd /usr/local/src                                    ; \
    pip install --no-cache-dir --upgrade pip; \
    pip install --no-cache-dir h5py; \
    pip install --no-cache-dir tornado; \
    pip install --no-cache-dir requests; \
    pip install --no-cache-dir pytz; \
    pip install --no-cache-dir watchdog; \
    pip install --no-cache-dir pymongo
WORKDIR /usr/local/src        
RUN git clone https://github.com/HDFGroup/hdf5-json.git  ; \
    cd hdf5-json                                         ; \
    python setup.py install                              ; \
    cd ..                                                ; \
    mkdir h5serv      
WORKDIR /usr/local/src/h5serv                                                         
COPY h5serv h5serv                                      
COPY util util                                        
COPY test test                                       
COPY data /data
RUN  cp /usr/local/src/hdf5-json/data/hdf5/tall.h5 /data ; \                                      
     ln -s /data

EXPOSE 5000

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
