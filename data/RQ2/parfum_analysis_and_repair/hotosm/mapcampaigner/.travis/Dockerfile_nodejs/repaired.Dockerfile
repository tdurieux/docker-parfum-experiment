FROM amazonlinux
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash \
  && yum install -y nodejs gcc-c++ make git && rm -rf /var/cache/yum
CMD ["npm", "install", "."]
