FROM gitpod/workspace-full:latest

USER gitpod

RUN npm i jest@24.8.0 -g && npm cache clean --force;
RUN npm i @learnpack/learnpack -g && learnpack plugins:install learnpack-node@0.0.21 && npm cache clean --force;
