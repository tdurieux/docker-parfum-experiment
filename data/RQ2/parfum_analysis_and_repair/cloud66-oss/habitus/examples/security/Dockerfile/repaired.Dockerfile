FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y wget openssh-client && rm -rf /var/lib/apt/lists/*;

# add the authorized host key for github (avoids "Host key verification failed")
RUN mkdir ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

ARG host
ENV PRIVATE_KEY /root/.ssh/id_rsa
RUN wget -O $PRIVATE_KEY https://$host:8080/v1/secrets/file/id_rsa \
&& chmod 0600 $PRIVATE_KEY \
&& ssh -T git@github.com \
&& rm $PRIVATE_KEY