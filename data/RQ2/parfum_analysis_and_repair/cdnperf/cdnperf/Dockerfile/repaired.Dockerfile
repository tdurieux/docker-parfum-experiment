FROM node:4
RUN git clone https://github.com/bebraw/cdnperf
RUN cd cdnperf && npm install && npm run build && npm cache clean --force;
EXPOSE 8090
CMD ["node", "/cdnperf/serve.js"]
