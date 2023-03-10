FROM ${jdk}

WORKDIR /home
<%
if (apm === 'skywalking') {
    print(`
COPY ../agent/skywalking /home/agent/skywalking`)
}
%>

COPY ./target/app.jar /home

ADD scripts/entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]