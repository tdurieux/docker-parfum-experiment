FROM ${jdk}

WORKDIR /home
<%
if (apm === 'skywalking') {
    print(`
COPY ./agent/skywalking /home/agent/skywalking`)
}
%>

COPY ./${artifactId}-provider/target/app.jar /home

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]