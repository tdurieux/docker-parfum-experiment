FROM python:2.7.10

LABEL maintainer="developers@optimizely.com"

# GitHub branch from which to build the SDK. Defaults to master
ARG SDK_BRANCH=master

ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH
COPY . $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir git+git://github.com/optimizely/python-sdk@${SDK_BRANCH}
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000
CMD ["python", "application.py"]
