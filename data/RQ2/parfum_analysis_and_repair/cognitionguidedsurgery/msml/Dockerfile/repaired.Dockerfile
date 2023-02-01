FROM wadoon/python

MAINTAINER Alexander Weigl <alexander.weigl@student.kit.edu>

ADD . /msml
WORKDIR /msml

RUN apt-get update
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev python-dev libz-dev python-vtk6 git wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y subversion libtet1.5-dev libcgal-dev libvtk6-dev python-vtk6 \
                       libboost-all-dev swig python-dev cmake && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r /msml/requirements.txt

ENV PYTHONPATH /msml
ENV ROOT /msml

# compile MSML
RUN (mkdir /msml/cbuild; cd /msml/cbuild; cmake /msml/operators && make -j 10 )
