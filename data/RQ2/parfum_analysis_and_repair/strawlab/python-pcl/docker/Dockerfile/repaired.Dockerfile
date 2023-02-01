# docker build -t ubuntu1604py36 .
FROM ubuntu:16.04

RUN apt-get update && \
        apt-get install --no-install-recommends -y software-properties-common vim && \
        add-apt-repository ppa:jonathonf/python-3.6 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y

RUN apt-get install --no-install-recommends cmake -y && \
    apt-get install --no-install-recommends -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends openni2-utils -y && \
    apt-get install --no-install-recommends libpcl-dev -y && rm -rf /var/lib/apt/lists/*;

# fork module
RUN git clone -b rc_patches4 https://github.com/Sirokujira/python-pcl.git
# main
# RUN git clone -b master https://github.com/strawlab/python-pcl.git

WORKDIR /python-pcl

# update pip
RUN python3.6 -m pip install pip --upgrade && \
    python3.6 -m pip install wheel

RUN pip install --no-cache-dir -r requirements.txt && \
    python3.6 setup.py build_ext -i && \
    python3.6 setup.py install

