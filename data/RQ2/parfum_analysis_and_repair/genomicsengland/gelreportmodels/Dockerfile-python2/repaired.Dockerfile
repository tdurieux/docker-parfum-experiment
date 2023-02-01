FROM ubuntu:bionic
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential software-properties-common openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
RUN apt-get update
RUN add-apt-repository ppa:webupd8team/java && apt-get update
RUN apt-get update
RUN apt-get install --no-install-recommends -y maven \
    python-dev python-pip python-virtualenv \
    libsasl2-dev libldap2-dev libssl-dev \
    nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install avrodoc -g && npm cache clean --force;
ENV PYTHONUNBUFFERED 1
RUN mkdir /gel
RUN mkdir /gel/GelReportModels
WORKDIR /gel
ADD . /gel/GelReportModels
RUN mkdir -p ~/.m2
WORKDIR /gel/GelReportModels
RUN pip install --no-cache-dir --upgrade pip==9.0.3
ENV GEL_REPORT_MODELS_PYTHON_VERSION 2
RUN pip install --no-cache-dir .
