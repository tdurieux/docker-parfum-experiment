FROM python:3.7
LABEL version="1.4.2.3"
LABEL maintainer="f5labs@f5.com"
RUN pip3 install --no-cache-dir pycurl
RUN pip3 install --no-cache-dir cryptonice
ENTRYPOINT ["cryptonice"]
CMD ["localhost"]
