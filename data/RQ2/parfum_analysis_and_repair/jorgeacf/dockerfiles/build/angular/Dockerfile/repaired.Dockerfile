FROM fedora:latest

RUN dnf -y install nodejs

RUN npm install -g @angular/cli && npm cache clean --force;

EXPOSE 4200