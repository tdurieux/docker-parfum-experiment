FROM node:12

WORKDIR /code
COPY ISS/static-src /code/
RUN npm ci
CMD npm run generate -- --outDir=/out --extDir=/ext