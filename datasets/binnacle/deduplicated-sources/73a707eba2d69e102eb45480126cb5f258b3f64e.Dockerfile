FROM node:10
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app


# Build backend code. 

COPY . /usr/src/app
RUN npm install && \
     npm cache clean --force && \
     npm run build 




# Build frontend code using a fixed hash commit. 

ENV FRONTEND_COMMIT_HASH d0dc50a56a13dff1c4bba6fc3491c54098b9c209

RUN mkdir -p /usr/src/app-frontend && cd /usr/src/app-frontend && \
    git clone https://github.com/githubsaturn/caprover-frontend.git && \
    cd caprover-frontend && \
    git reset --hard ${FRONTEND_COMMIT_HASH} && \
    npm install && npm cache clean --force && \
    npm run build && \
    mv ./build ../../app/dist-frontend && \
    cd / && \
    rm -rf /usr/src/app-frontend

ENV NODE_ENV production
ENV PORT 3000
EXPOSE 3000

CMD ["npm" , "start"]
