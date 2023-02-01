FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y ruby libjpeg8 libxrender1 libfontconfig1 && rm -rf /var/lib/apt/lists/*;

CMD /root/wkhtmltopdf_binary_gem/bin/wkhtmltopdf --version
