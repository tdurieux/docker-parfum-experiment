FROM node:11-alpine
COPY anemometer.js /src/anemometer.js
COPY entrypoint.sh /entrypoint.sh
RUN npm i axios ethers fs && npm cache clean --force;
RUN mkdir iexec_out
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]