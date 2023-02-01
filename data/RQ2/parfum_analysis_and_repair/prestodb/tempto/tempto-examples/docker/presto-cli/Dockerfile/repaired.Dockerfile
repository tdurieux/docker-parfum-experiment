FROM prestodb/centos6-oj8
MAINTAINER Presto community <https://prestodb.io/community.html>

RUN curl -f -SL https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-cli/0.181/presto-cli-0.181-executable.jar -o presto-cli.jar

