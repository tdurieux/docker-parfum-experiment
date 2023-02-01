FROM centos:8
MAINTAINER siewer

# Required package installation
RUN yum update -y
RUN yum install java-11-openjdk-devel -y && rm -rf /var/cache/yum
RUN yum install maven -y && rm -rf /var/cache/yum
RUN yum install git -y && rm -rf /var/cache/yum
RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install python3-pip -y && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir bandit
RUN pip3 install --no-cache-dir pipreqs
RUN yum install nodejs -y && rm -rf /var/cache/yum
RUN yum install php-cli php-zip wget unzip php-json -y && rm -rf /var/cache/yum
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "copy('https://github.com/designsecurity/progpilot/releases/download/v0.8.0/progpilot_v0.8.0.phar', 'progpilot.phar');"
RUN chmod +x progpilot.phar
RUN mv progpilot.phar /bin/progpilot

# TLS Support
RUN mkdir /opt/pki
RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/O=mixeway.io/CN=mixewayscanner" -keyout certificate.key -out certificate.crt
RUN openssl pkcs12 -export -in certificate.crt -inkey certificate.key -out certificate.p12 -name "mixeway" -password pass:1qaz@WSX
RUN mv certificate.p12 /opt/pki/certificate.p12

# Download DTrack
RUN mkdir /opt/dtrack && wget https://github.com/DependencyTrack/dependency-track/releases/download/3.8.0/dependency-track-embedded.war -O /opt/dtrack/dependency-track-embedded.war

# Building Mixeway Scanner APP
WORKDIR /app
COPY ./pom.xml ./pom.xml
RUN mvn dependency:go-offline -B

COPY ./src ./src
RUN mvn package -DskipTests && cp target/*.jar app.jar

# Copy startup script
COPY ./startup.sh ./startup.sh

ENTRYPOINT ["/bin/bash", "/app/startup.sh"]