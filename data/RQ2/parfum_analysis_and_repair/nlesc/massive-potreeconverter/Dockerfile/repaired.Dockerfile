# DockertFile for the Massive-PotreeConverter
FROM ubuntu:16.04
MAINTAINER Oscar Martinez Rubi <o.rubi@esciencecenter.nl>
RUN apt-get update -y

# INSTALL compilers and build toold
RUN apt-get install --no-install-recommends -y wget git cmake build-essential gcc g++ && rm -rf /var/lib/apt/lists/*;

# INSTALL PDAL
RUN apt-get install --no-install-recommends -y libgeos-dev libproj-dev libtiff-dev libgeotiff-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt
RUN wget https://download.osgeo.org/laszip/laszip-2.1.0.tar.gz
RUN tar xvfz laszip-2.1.0.tar.gz && rm laszip-2.1.0.tar.gz
WORKDIR /opt/laszip-2.1.0
RUN mkdir makefiles
WORKDIR /opt/laszip-2.1.0/makefiles/
RUN cmake ..
RUN make; make install
WORKDIR /opt
RUN wget https://download.osgeo.org/pdal/PDAL-1.3.0-src.tar.gz
RUN tar xvzf PDAL-1.3.0-src.tar.gz && rm PDAL-1.3.0-src.tar.gz
WORKDIR /opt/PDAL-1.3.0-src
RUN mkdir makefiles
WORKDIR /opt/PDAL-1.3.0-src/makefiles
RUN apt-get install --no-install-recommends -y libjsoncpp-dev && rm -rf /var/lib/apt/lists/*;
RUN cmake -G "Unix Makefiles" ../
RUN make ; make install

# INSTALL PotreeConverter
WORKDIR /opt
RUN git clone https://github.com/m-schuetz/LAStools.git LAStools-PC
WORKDIR /opt/LAStools-PC/LASzip
RUN mkdir build
WORKDIR /opt/LAStools-PC/LASzip/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
WORKDIR /opt
RUN git clone https://github.com/potree/PotreeConverter.git
WORKDIR /opt/PotreeConverter
RUN mkdir build
WORKDIR /opt/PotreeConverter/build
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/opt/LAStools-PC/LASzip/dll -DLASZIP_LIBRARY=/opt/LAStools-PC/LASzip/build/src/liblaszip.so ..
RUN make ; make install
#RUN ln -s /opt/PotreeConverter/build/PotreeConverter/PotreeConverter /usr/local/bin/PotreeConverter

# INSTALL LAStools
WORKDIR /opt
RUN wget https://www.cs.unc.edu/~isenburg/lastools/download/lastools.zip
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN unzip lastools.zip
WORKDIR /opt/LAStools/
RUN make
RUN ln -s /opt/LAStools/bin/lasinfo /usr/local/sbin/lasinfo
RUN ln -s /opt/LAStools/bin/lasmerge /usr/local/sbin/lasmerge


# INSTALL pycoeman
RUN apt-get install --no-install-recommends -y python-pip python-dev build-essential libfreetype6-dev libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+https://github.com/NLeSC/pycoeman

# INSTALL Massive-PotreeConverter
RUN pip install --no-cache-dir git+https://github.com/NLeSC/Massive-PotreeConverter

# Create 3 volumes to be used when running the script. Ideally each run must be mounted to a different physical device
VOLUME ["/data1"]
VOLUME ["/data2"]
VOLUME ["/data3"]

WORKDIR /data1
