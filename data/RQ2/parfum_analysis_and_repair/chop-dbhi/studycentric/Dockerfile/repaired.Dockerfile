# StudyCentric

FROM ubuntu:vivid

MAINTAINER Jeff Miller "millerjm1@email.chop.edu"

RUN apt-get update -qq --fix-missing
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    build-essential \
    git-core \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libffi-dev \
    openssl \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdcm2.4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-gdcm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

# Python dependencies
RUN pip install --no-cache-dir "Django==1.5"
RUN pip install --no-cache-dir "requests"
RUN pip install --no-cache-dir "pydicom"
RUN pip install --no-cache-dir "uWSGI"

ADD . /opt/app

# Ensure all python requirements are met
ENV APP_NAME STUDYCENTRIC

CMD ["/opt/app/scripts/http.sh"]

EXPOSE 8000
