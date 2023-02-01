FROM python:3

WORKDIR /home

RUN pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir pymysql pymongo boto3 requests
ADD layer.tar /

EXPOSE 8687
ENV PYTHONPATH=/swifty

#
# Run wdog daemon inside
CMD [ "/usr/bin/swy-wdog" ]
