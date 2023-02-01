# https://mothergeo-py.readthedocs.io/en/latest/development/how-to/gdal-ubuntu-pkg.html

FROM ubuntu:latest

# Setup python if you don't have it yet
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
RUN which -a python || true ;\
    which -a python3 || true ;\
    which -a pip || true ;\
    which -a pip3 || true

# Install GDAL binaries
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update && apt-get update
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdal-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN gdal-config --version

# Install GDAL python
RUN python3 -m pip install --global-option=build_ext --global-option="-I/usr/include/gdal" GDAL==`gdal-config --version`
RUN python3 -c 'from osgeo import gdal; print(gdal.__version__)'

# Install Rtree
RUN apt-get -y --no-install-recommends install python3-rtree && rm -rf /var/lib/apt/lists/*;
RUN python3 -c 'import rtree; print(rtree.__version__)'

# Instrall opencv deps
RUN apt install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

# Install buzzard
RUN python3 -m pip install buzzard
RUN python3 -c 'import buzzard as buzz; print(buzz.__version__)'
