FROM openjdk:latest
RUN curl -f -sL https://rpm.nodesource.com/setup_12.x | bash - \
  && yum install -y nodejs && rm -rf /var/cache/yum
