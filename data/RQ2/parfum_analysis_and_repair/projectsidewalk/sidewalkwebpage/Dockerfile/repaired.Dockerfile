FROM openjdk:8-jdk-stretch

RUN apt-get update && apt-get upgrade -y

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
  curl -f -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
  apt-get update

RUN apt-get install --no-install-recommends -y \
    unzip \
    python-dev \
    python-pip \
    libblas-dev \
    liblapack-dev \
    gfortran \
    python-numpy \
    python-pandas \
    sbt && \
  apt-get autoremove && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

COPY package.json ./
COPY requirements.txt ./

RUN pip install --no-cache-dir --upgrade setuptools && \
  pip install --no-cache-dir -r requirements.txt

RUN npm install && npm cache clean --force;
