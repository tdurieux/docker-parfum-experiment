FROM node:10
RUN git clone https://github.com/ReactiveX/rxjs /rxjs
WORKDIR /rxjs
RUN git pull
COPY --from=typescript/typescript /typescript/typescript-*.tgz /typescript.tgz
RUN mkdir /typescript
RUN tar -xzvf /typescript.tgz -C /typescript && rm /typescript.tgz
RUN rm ./package-lock.json
RUN npm i -D typescript@/typescript/package && npm cache clean --force;
RUN npm install && npm cache clean --force;
# Set entrypoint back to bash (`node` base image made it `node`)
ENTRYPOINT [ "/bin/bash", "-c" , "exec \"${@:0}\";"]
# Build
CMD npm run build_all