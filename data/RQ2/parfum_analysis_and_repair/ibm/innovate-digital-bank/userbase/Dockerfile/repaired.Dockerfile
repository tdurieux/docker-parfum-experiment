FROM ibmcom/ibmnode:latest
LABEL maintainer="amalamine@ae.ibm.com"

#RUN apt-get install -y nodejs npm

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm cache clean --force; npm prune --production
ENV NODE_ENV production
ENV PORT 4200

EXPOSE 4200
CMD [ "npm","start" ]
