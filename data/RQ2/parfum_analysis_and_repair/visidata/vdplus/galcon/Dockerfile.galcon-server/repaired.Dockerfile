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
COPY --from=intermediate /vdplus /vdplus
WORKDIR "vdplus/galcon"

RUN pip install --no-cache-dir .
EXPOSE 8080
ENTRYPOINT ["galcon-server.py", "-p 8080"]
