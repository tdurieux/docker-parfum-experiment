FROM node:12.16.1-alpine3.11

EXPOSE 3000

ARG COMMON_BACKEND_URL
ARG COMMON_FRONTEND_URL
ARG COMMON_STRIPE_YEARLY_PLAN_ID
ARG COMMON_STRIPE_MONTHLY_PLAN_ID
ARG WEB_APP_STRIPE_PUBLISHABLE_KEY
ARG WEB_APP_GOOGLE_API_KEY
ARG WEB_APP_MARKETING_SITE
ARG WEB_APP_SENTRY_DSN


# Set environment variables
ENV COMMON_BACKEND_URL=$COMMON_BACKEND_URL
ENV COMMON_FRONTEND_URL=$COMMON_FRONTEND_URL
ENV COMMON_STRIPE_YEARLY_PLAN_ID=$COMMON_STRIPE_YEARLY_PLAN_ID
ENV COMMON_STRIPE_MONTHLY_PLAN_ID=$COMMON_STRIPE_MONTHLY_PLAN_ID
ENV WEB_APP_STRIPE_PUBLISHABLE_KEY=$WEB_APP_STRIPE_PUBLISHABLE_KEY
ENV WEB_APP_GOOGLE_API_KEY=$WEB_APP_GOOGLE_API_KEY
ENV WEB_APP_MARKETING_SITE=$WEB_APP_MARKETING_SITE
ENV WEB_APP_SENTRY_DSN=$WEB_APP_SENTRY_DSN

# Setup working directory. All the paths will be relative to WORKDIR
WORKDIR /usr/src/app

# Add custom nginx config
ADD nginx.conf ./
# Rename nginx.conf to nginx.conf.sigil, since that is what Dokku expects
RUN mv nginx.conf nginx.conf.sigil

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

# Copy all source files into docker container
COPY . .

# Build the app
RUN yarn build && yarn cache clean;

# Run the app
CMD [ "yarn", "start" ]