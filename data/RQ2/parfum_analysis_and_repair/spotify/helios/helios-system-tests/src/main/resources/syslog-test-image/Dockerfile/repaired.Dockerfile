FROM spotify/alpine:latest

RUN curl -f -L -o /tmp/syslog-redirector.zip https://github.com/spotify/syslog-redirector/releases/download/0.0.5/syslog-redirector.zip
RUN unzip /tmp/syslog-redirector.zip syslog-redirector -d / && rm /tmp/syslog-redirector.zip

ENTRYPOINT ["/bin/sh"]
CMD ["-c", "echo should-be-redirected"]
