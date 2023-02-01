#    SYMON
#    Copyright (C) 2021  SYMON Contributors
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM node:lts-alpine as build

# Stage 1: Build
# Get build args
ARG NODE_ENV="production"
ARG DATABASE_URL="file:./dev.db"
ARG REACT_APP_API_URL="http://localhost:8080"
ARG REACT_APP_API_PREFIX="/v1"
ARG REACT_APP_GIT_HASH=""

# Set ENV from ARG
ENV NODE_ENV ${NODE_ENV}
ENV DATABASE_URL ${DATABASE_URL}
ENV REACT_APP_API_URL ${REACT_APP_API_URL}
ENV REACT_APP_API_PREFIX ${REACT_APP_API_PREFIX}
ENV REACT_APP_GIT_HASH ${REACT_APP_GIT_HASH}

WORKDIR /usr/app/symon

# Copy files needed
COPY package-lock.json .
COPY package.json .
COPY postcss.config.js .
COPY tailwind.config.js .
COPY tsconfig.json .
COPY webpack.config.js .
COPY config/nginx.conf .

# Copy the client code
RUN mkdir src
COPY src/client src/client
COPY src/server/prisma src/server/prisma

# Build the frontend
RUN npm ci --also=dev

# Generate prisma and migrate
RUN npx prisma migrate dev --preview-feature

RUN npm run client:build

# Stage 2: Deploy
FROM nginx:stable

# Copy the built frontend to the nginx directory
COPY --from=build /usr/app/symon/dist /usr/share/nginx/html

# Delete default nginx configuration and replace it with the new one
RUN rm -rf /etc/nginx/conf.d/*
COPY --from=build /usr/app/symon/nginx.conf /etc/nginx/conf.d/nginx.conf

# Expose to port 80
EXPOSE 80

# Run using nginx daemon