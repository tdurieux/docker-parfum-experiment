FROM ubuntu:18.04

#########################################
### Python                                                              
RUN apt-get update && apt-get -y --no-install-recommends install git wget build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN ln -s python3 /usr/bin/python
RUN ln -s pip3 /usr/bin/pip
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python3-tk && rm -rf /var/lib/apt/lists/*;

#########################################
### Numpy
RUN pip install --no-cache-dir numpy

#########################################
### Make sure we have python3 and a working locale
RUN rm /usr/bin/python && ln -s python3 /usr/bin/python && rm /usr/bin/pip && ln -s pip3 /usr/bin/pip
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN apt-get install --no-install-recommends -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

# Install SpyKING CIRCUS
RUN apt-get update && apt-get install --no-install-recommends -y libmpich-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyqt5==5.13
RUN apt-get update && apt-get install --no-install-recommends -y qt5-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libglib2.0-0 libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y packagekit-gtk3-module libcanberra-gtk-module libcanberra-gtk3-module && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-build
RUN pip install --no-cache-dir cmake==3.13.3
RUN pip install --no-cache-dir spyking-circus==0.9.7

# python packages
RUN pip install --no-cache-dir spikeextractors==0.7.1 spiketoolkit==0.5.1 spikesorters==0.2.3
RUN pip install --no-cache-dir kachery==0.4.8