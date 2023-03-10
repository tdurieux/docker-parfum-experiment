ARG version=latest
FROM openjdk:$version

# version <= 11
RUN apt-get update \
    && apt-get install --no-install-recommends -y make maven || true && rm -rf /var/lib/apt/lists/*;
COPY prism/prism/nginx/cert.crt /usr/local/share/ca-certificates/cert.crt
RUN update-ca-certificates || true

# version > 11
RUN yum update -y \
    && yum install -y make wget || true && rm -rf /var/cache/yum
RUN wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo \
    && yum install -y maven || true && rm -rf /var/cache/yum
RUN keytool -import -trustcacerts -cacerts -storepass changeit -noprompt \
    -alias api.sendgrid.com -file /usr/local/share/ca-certificates/cert.crt || true

WORKDIR /app
COPY . .

RUN make install
