# PcapXray Project Dockerfile - https://github.com/Srinivas11789/PcapXray

# Latest ubuntu base image
FROM ubuntu:latest

# Maintainer
MAINTAINER Srinivas Piskala Ganesh Babu "spg349@nyu.edu"

# Apt update and install - nginx and git
#RUN apt-get update && apt-get upgrade -y
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pil && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pil.imagetk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnss3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-xcb1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
     apt-get install -yq --no-install-recommends \ 
     libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \ 
     libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \ 
     libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \ 
     libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \ 
     libnss3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;

# Fetching the latest source code from the github repo of pcapxray
RUN git clone https://github.com/srinivas11789/PcapXray

### Master branch changes - srinivas11789/pcapxray
RUN pip3 install --no-cache-dir --upgrade -r PcapXray/requirements.txt

WORKDIR PcapXray/Source
CMD python3 main.py

### Develop/Beta branch changes - srinivas11789/pcapxray-beta
#WORKDIR PcapXray
#RUN git checkout develop
#RUN pip install -r requirements.txt
#WORKDIR Source
#CMD python main.py

