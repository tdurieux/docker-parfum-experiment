FROM node:16-alpine3.15 as solidity-builder
RUN apk add --no-cache python3 alpine-sdk
USER node
WORKDIR /home/node
ADD --chown=node:node ./samples/solidity/package*.json ./
RUN npm install && npm cache clean --force;
ADD --chown=node:node ./samples/solidity .
RUN npx hardhat compile

FROM node:16-alpine3.15 as builder
WORKDIR /root
ADD package*.json ./
RUN npm install && npm cache clean --force;
ADD . .
RUN npm run build

FROM node:16-alpine3.15
RUN apk add --no-cache curl
WORKDIR /root
ADD package*.json ./
RUN npm install --production && npm cache clean --force;
COPY --from=solidity-builder /home/node/contracts contracts/source
COPY --from=solidity-builder /home/node/artifacts/contracts/ERC1155MixedFungible.sol contracts
COPY --from=builder /root/dist dist
COPY --from=builder /root/.env /root/.env
EXPOSE 3000
CMD ["npm", "run", "start:prod"]
