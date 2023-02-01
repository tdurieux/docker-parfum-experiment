FROM ubuntu as intermediate

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 0400 /root/.ssh/id_rsa


# make sure domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone git@github.com:saulpw/vdplus.git
WORKDIR "vdplus"
RUN git pull


FROM python:3.9-alpine3.13

RUN apk add --no-cache git
# copy repo from previous image
COPY --from=intermediate /vdplus/galcon /galcon

WORKDIR "/galcon"
RUN pip install --no-cache-dir .
ENV TERM="xterm-256color"
RUN sh -c "echo >>~/.visidatarc import galcon"
ENV IPADDR=1.1.1.1  # 172.17.0.2
ENTRYPOINT ["sh", "-c", "vd galcon+http://${IPADDR}:8080"]
