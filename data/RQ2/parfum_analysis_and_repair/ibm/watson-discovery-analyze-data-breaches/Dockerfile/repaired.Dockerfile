FROM ibmcom/ibmnode

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

ADD . /app
WORKDIR "/app"

RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
