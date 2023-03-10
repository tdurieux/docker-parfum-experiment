FROM python:3.7

# install PAI python support
RUN pip install --no-cache-dir pypai

# install go needed by installing ElasticDL
ENV GOPATH /root/go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
RUN curl -f --silent https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# install ElasticDL to manage ElasticDL jobs
RUN git clone https://github.com/sql-machine-learning/elasticdl.git && \
cd elasticdl && \
git checkout 62b255a918df5b6594c888b19aebbcc74bbce6e4 && \
 pip install --no-cache-dir -r elasticdl/requirements.txt && \
python setup.py install && \
cd .. && rm -rf elasticdl
