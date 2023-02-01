FROM ubuntu:20.04
MAINTAINER Thanasis Karampatsis <tkarabatsis@athenarc.gr>

ENV LANG=C.UTF-8

# Setting up timezone
ENV TZ=Etc/GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update

# Installing python
RUN apt install -y --no-install-recommends python2 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python2 /usr/bin/python

# Installing Exareme requirements
RUN apt install --no-install-recommends -y openjdk-8-jdk curl jq iputils-ping && rm -rf /var/lib/apt/lists/*;

# Installing pip
RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN apt-get install --no-install-recommends -y python-dev \
     build-essential libssl-dev libffi-dev \
     libxml2-dev libxslt1-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

ADD files/requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt
RUN pip install --no-cache-dir scipy==1.2.1 scikit-learn==0.20.3
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir lifelines
RUN pip install --no-cache-dir liac-arff
RUN pip install --no-cache-dir sqlalchemy
RUN pip install --no-cache-dir pathlib
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir colour
RUN pip install --no-cache-dir tornado
RUN pip install --no-cache-dir statsmodels==0.10.2

# Installing R
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt update
RUN apt install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*;
RUN Rscript -e 'install.packages("randomForest", repos="https://cloud.r-project.org")'

RUN Rscript -e 'install.packages("caret")'
RUN Rscript -e 'install.packages("e1071")'
RUN pip install --no-cache-dir rpy2==2.8.6

# Add Madis Server
ADD src/madisServer /root/madisServer

# Add Exareme
ADD src/exareme/exareme-distribution/target/exareme /root/exareme
ADD files/root /root
RUN chmod -R 755 /root/exareme/*.py /root/exareme/*.sh

# Add the algorithms
ADD src/mip-algorithms /root/mip-algorithms

EXPOSE 9090
EXPOSE 22

ENV USER=root
ENV PYTHONPATH "${PYTHONPATH}:/root/mip-algorithms"
WORKDIR /root/exareme

CMD ["/bin/bash","bootstrap.sh"]

