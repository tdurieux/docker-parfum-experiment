FROM bde2020/spark-submit:3.3.0-hadoop3.3

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>"

COPY template.sh /

# Copy the requirements.txt first, for separate dependency resolving and downloading
ONBUILD COPY requirements.txt /app/
 \
RUN cd /app \
      && pip3 install --no-cache-dir -r requirements.txtONBUILD


# Copy the source code
ONBUILD COPY . /app

CMD ["/bin/bash", "/template.sh"]
