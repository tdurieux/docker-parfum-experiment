FROM soajsorg/node

RUN mkdir -p /opt/soajs/soajs.urac/node_modules/
WORKDIR /opt/soajs/soajs.urac/
COPY . .
RUN npm install && npm cache clean --force;

CMD ["/bin/bash"]