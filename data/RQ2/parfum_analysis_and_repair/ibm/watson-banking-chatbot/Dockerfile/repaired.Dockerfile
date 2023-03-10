FROM ibmcom/ibmnode

ADD . /app

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

WORKDIR "/app"

RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
