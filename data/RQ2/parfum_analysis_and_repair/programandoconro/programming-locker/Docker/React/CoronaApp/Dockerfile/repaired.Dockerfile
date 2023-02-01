FROM node
RUN apt update -y && \
apt upgrade -y && \
 apt install --no-install-recommends git -y && \
npm install -g create-react-app && \
git clone https://github.com/programandoconro/project_corona_tracker && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
WORKDIR ./project_corona_tracker
RUN npm install -g serve && \
npm install && npm run build && npm cache clean --force;
EXPOSE 5000
CMD serve -s build
