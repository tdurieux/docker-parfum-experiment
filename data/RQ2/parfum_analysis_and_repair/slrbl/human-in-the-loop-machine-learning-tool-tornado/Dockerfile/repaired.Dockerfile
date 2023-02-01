FROM ruby:2.5

RUN apt-get update
RUN echo "y" | apt-get install -y --no-install-recommends libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install python3
#RUN apt-get -y install python3-pip
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential tk-dev libncurses5-dev \
libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev \
libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz

RUN tar zxf Python-3.8.2.tgz && rm Python-3.8.2.tgz
WORKDIR /Python-3.8.2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make -j4
RUN make altinstall

RUN apt-get -y --no-install-recommends install ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libxml2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.8 get-pip.py
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir sklearn
RUN pip install --no-cache-dir argparse
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir pillow

RUN mkdir /tornado
COPY . /tornado
WORKDIR /tornado
#RUN gem update --system
RUN gem install sqlite3 -v '1.3.13' --source 'https://rubygems.org/'
RUN gem install globalid -v 0.4.2
RUN gem install rails
