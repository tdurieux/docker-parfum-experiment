FROM node:14-alpine3.10

WORKDIR /opt/liwords-ui/

ENV PATH /opt/liwords-ui/node_modules/.bin:$PATH

COPY ./liwords-ui/package.json ./liwords-ui/package-lock.json ./
RUN mkdir -p wolges-wasm-pkg && echo '{}' > wolges-wasm-pkg/package.json

RUN ["npm", "ci"]

EXPOSE 3000

CMD ["npm", "start"]