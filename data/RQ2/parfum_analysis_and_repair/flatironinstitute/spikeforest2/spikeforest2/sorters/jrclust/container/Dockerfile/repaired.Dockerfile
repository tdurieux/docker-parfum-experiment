FROM nvidia/cuda:10.1-base-ubuntu18.04

RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir /install_matlab \
    && curl -f https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/1/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_1_glnxa64.zip > /install_matlab/MATLAB_Runtime_R2019b_Update_1_glnxa64.zip \
    && cd /install_matlab && unzip MATLAB_Runtime_R2019b_Update_1_glnxa64.zip && ./install -mode silent -agreeToLicense yes && cd / && rm -rf /install_matlab

ENV LD_LIBRARY_PATH /usr/local/MATLAB/MATLAB_Runtime/v97/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v97/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v97/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v97/extern/bin/glnxa64

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

#########################################
### Compiled jrclust
### To generate (matlab compiler required):
###    See matlab/ directory
COPY jrclust_binary /jrclust_binary
RUN chmod a+x /jrclust_binary
ENV JRCLUST_BINARY_PATH=/jrclust_binary

# python packages
RUN pip install --no-cache-dir spikeextractors==0.7.0 spiketoolkit==0.5.0
RUN pip install --no-cache-dir spikesorters==0.2.2

RUN pip install --no-cache-dir kachery==0.4.6