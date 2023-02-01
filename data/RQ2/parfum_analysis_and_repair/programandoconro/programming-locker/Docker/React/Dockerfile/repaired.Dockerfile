FROM ubuntu
RUN apt update -y && apt install --no-install-recommends npm -y && \
npm install -g create-react-app && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN create-react-app sample
WORKDIR ./sample
EXPOSE 5000
COPY ./app/App.js ./src
RUN npm run build
RUN npm install -g serve && npm cache clean --force;
