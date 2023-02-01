FROM python:2.7

EXPOSE 8888

RUN apt-get update && apt-get install --no-install-recommends -y mysql-client && rm -rf /var/lib/apt/lists/*;

# based on python:2.7-onbuild, but if we use that image directly
# the above apt-get line runs too late.
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

CMD python blog.py --mysql_host=mysql
