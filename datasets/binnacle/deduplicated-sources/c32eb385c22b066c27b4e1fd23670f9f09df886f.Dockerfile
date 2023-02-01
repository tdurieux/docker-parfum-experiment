FROM node:10
RUN apt-get update
RUN apt-get -y install netcat socat
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV development

EXPOSE 38000
EXPOSE 3000

# I don't know why, but for some reason this port
# forwarding is necessary for NodeJs debugger to be able to attach!!

RUN echo "(socat -v  tcp-listen:38000,reuseaddr,fork tcp:localhost:38213) & \n node --inspect-brk=38213 /usr/src/app/bin/www" > /usr/run-brk.sh
RUN echo "(socat -v  tcp-listen:38000,reuseaddr,fork tcp:localhost:38213) & \n node --inspect=38213 /usr/src/app/bin/www" > /usr/run.sh
RUN chmod +x /usr/run.sh
RUN chmod +x /usr/run-brk.sh
CMD ["/bin/bash" , "-c" , "/usr/run.sh" ]

###  Debugging only works with chrome tools. Copy and past URL printed when service starts (starts with chrome-dev)
###  Just replace the port with 38000
###  change --inspect to --inspect-brk to make node wait until debug is attached.
