FROM ubuntu:18.04

#########################################
### Python, etc                                                                                                               
RUN apt-get update && apt-get -y --no-install-recommends install git wget build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN ln -s python3 /usr/bin/python
RUN ln -s pip3 /usr/bin/pip
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python3-tk && rm -rf /var/lib/apt/lists/*;

RUN echo "Installing SpyKING CIRCUS and phy 2.0..."

#########################################
### Spyking Circus
RUN apt-get update && apt-get install --no-install-recommends -y libmpich-dev mpich && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y qt5-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libglib2.0-0 libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y packagekit-gtk3-module libcanberra-gtk-module libcanberra-gtk3-module && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-build
RUN pip install --no-cache-dir cmake
RUN pip install --no-cache-dir spyking-circus

### Phy
RUN pip install --no-cache-dir pyqt5 colorcet pyopengl qtconsole requests traitlets tqdm joblib click mkdocs
RUN pip install --no-cache-dir https://github.com/cortex-lab/phylib/archive/master.zip
RUN pip install --no-cache-dir https://github.com/cortex-lab/phy/archive/master.zip