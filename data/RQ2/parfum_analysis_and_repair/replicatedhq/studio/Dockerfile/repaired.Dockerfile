FROM node:8.7
RUN npm install -g replicated-studio && npm cache clean --force;
EXPOSE 8006
CMD ["replicated-studio"]
