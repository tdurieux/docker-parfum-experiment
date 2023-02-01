FROM gitpod/workspace-full

RUN npm uninstall angular-cli @angular/cli
RUN npm install @angular/cli@8.0.3 && npm cache clean --force;

# Install building dependencies
RUN npm install --save-dev @angular/cli@8.0.3 && npm cache clean --force;
RUN npm install --save-dev @angular-devkit/build-angular && npm cache clean --force;