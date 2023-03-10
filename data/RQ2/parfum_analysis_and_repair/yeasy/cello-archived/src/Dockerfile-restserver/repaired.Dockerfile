FROM python:3.5
MAINTAINER Baohua Yang <"baohyang@cn.ibm.com">
ENV TZ Asia/Shanghai

WORKDIR /app
COPY ./requirements.txt /app
RUN pip install --no-cache-dir  -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com -r requirements.txt

COPY . /app

# use this in development
CMD ["python", "restserver.py"]

# use this in product
#CMD ["gunicorn", "-w", "128", "-b", "0.0.0.0:80", "restserver:app"]