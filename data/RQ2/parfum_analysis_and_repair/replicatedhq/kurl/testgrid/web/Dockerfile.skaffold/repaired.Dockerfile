FROM node:14

WORKDIR /src
ADD package*.json ./
ADD Makefile ./
RUN make deps
COPY . .

EXPOSE 30881
ENTRYPOINT ["make", "serve"]