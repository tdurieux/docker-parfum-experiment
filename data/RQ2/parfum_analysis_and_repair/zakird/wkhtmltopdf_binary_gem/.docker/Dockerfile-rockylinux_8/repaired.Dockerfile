FROM rockylinux/rockylinux:8

RUN yum install -y ruby libjpeg-turbo libpng libXrender fontconfig libXext && rm -rf /var/cache/yum

CMD /root/wkhtmltopdf_binary_gem/bin/wkhtmltopdf --version
