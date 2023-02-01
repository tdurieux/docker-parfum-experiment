FROM reg.docker.alibaba-inc.com/abm-aone/maven AS build
COPY . /app
RUN cd /app && mvn -f pom_private.xml -Dmaven.test.skip=true clean package