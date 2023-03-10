FROM golang

RUN apt-get update \
	&& apt-get install --no-install-recommends -y bzr-git atftp \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*;

VOLUME /var/lib/tftpboot

COPY . /go/src/github.com/tftp-go-team/hooktftp
WORKDIR /go/src/github.com/tftp-go-team/hooktftp

RUN make build

RUN echo '\
user: nobody\n\
\n\
hooks:\n\
    - type: file\n\
      regexp: ^.*$\n\
      template: /var/lib/tftpboot/$0' > /etc/hooktftp.yml

CMD ./hooktftp -v
