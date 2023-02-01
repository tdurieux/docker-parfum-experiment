FROM python:3.7

# install ubuntu packages.
RUN DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing && apt-get install --no-install-recommends -y \
    libxml2-dev \
    libxslt1-dev \
    libxmlsec1-dev \
 && apt-get clean \
 && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

RUN mkdir /matchminerAPI
COPY ./requirements.txt /matchminerAPI/requirements.txt
WORKDIR /matchminerAPI

RUN pip install --no-cache-dir -r requirements.txt

# Hack to work around https://github.com/py-bson/bson/issues/82
RUN pip --no-input uninstall --yes bson
RUN pip --no-input uninstall --yes pymongo
RUN pip install --no-cache-dir 'pymongo==3.10'
