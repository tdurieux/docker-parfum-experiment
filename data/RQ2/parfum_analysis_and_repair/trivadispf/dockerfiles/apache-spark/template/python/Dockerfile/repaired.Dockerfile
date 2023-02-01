FROM trivadis/apache-spark-submit:3.0.0pv2-hadoop2.7

MAINTAINER Cecile Tonglet <cecile.tonglet@tenforce.com>

COPY template.sh /

# Copy the requirements.txt first, for separate dependency resolving and downloading
ONBUILD COPY requirements.txt /app/
 \
RUN cd /app \
      && pip3 install --no-cache-dir -r requirements.txtONBUILD


# Copy the source code
ONBUILD COPY . /app

CMD ["/bin/bash", "/template.sh"]
