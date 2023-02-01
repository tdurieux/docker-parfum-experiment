FROM osgeo/gdal:ubuntu-full-3.4.0

RUN apt-get update
RUN apt-get install --no-install-recommends python3-pip git -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libnetcdf-dev libnetcdff-dev libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gfortran -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends python2 -y && rm -rf /var/lib/apt/lists/*;
