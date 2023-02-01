FROM node:11.9.0 as pnpm
ENV PNPM_VERSION 4.11.6 # Control pnpm version dependency explicitly
RUN curl -sL https://unpkg.com/@pnpm/self-installer | node

######################
####### BUILD ########
######################
FROM pnpm as builder
WORKDIR /usr/pisa

# copy the package files
COPY package.json ./
COPY ./pnpm-lock.yaml ./
COPY ./pnpm-workspace.yaml ./
COPY ./.npmrc ./
COPY ./packages ./packages
COPY ./tsconfig*.json ./

# install and build
RUN ["pnpm", "i", "--frozen-lockfile"]
RUN ["pnpm", "-r", "run", "build"]

######################
####### PROD PACKAGES ########
######################
FROM node:10.14.2 as productionPackages
WORKDIR /usr/pisa

# copy the package files
COPY package*.json ./
COPY ./packages ./packages

# install only prod
RUN ["pnpm", "i", "--frozen-lockfile", "--prod"]

######################
####### deploy ########
######################
FROM node:10.14.2 as deploy
WORKDIR /usr/pisa

COPY --from=productionPackages /usr/pisa/node_modules ./node_modules
COPY --from=builder /usr/pisa/packages ./packages
RUN ["ln", "-s", "./packages/server/lib", "./dist"]

# expose the startup port
EXPOSE 3000
# start the application
# we cant use npm run start since it causes problems with graceful exit within docker
# see https://medium.com/@becintec/building-graceful-node-applications-in-docker-4d2cd4d5d392 for more details
CMD ["node", "./dist/index.js"]