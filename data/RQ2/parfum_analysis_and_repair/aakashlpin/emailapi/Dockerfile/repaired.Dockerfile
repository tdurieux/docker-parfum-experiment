FROM ubuntu:18.04
# https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
ENV TZ=Asia/Kolkata
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y

# Install Node.js
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg-agent && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -f --silent --location https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;
RUN node --version
RUN yarn --version

RUN apt-get install --no-install-recommends -y qpdf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN python3 --version
RUN apt-get install --no-install-recommends -y python3-tk ghostscript && rm -rf /var/lib/apt/lists/*;
RUN gs -version
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir 'opencv-python==4.2.0.34'
RUN pip3 install --no-cache-dir "camelot-py[cv]"

WORKDIR /codebase
COPY package.json ./
COPY yarn.lock ./
RUN yarn
COPY . ./
ARG NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
ARG NEXT_PUBLIC_FIREBASE_DATABASE_URL
ARG FIREBASE_CLIENT_EMAIL
ARG NEXT_PUBLIC_FIREBASE_PROJECT_ID
ARG NEXT_PUBLIC_FIREBASE_PUBLIC_API_KEY
ARG FIREBASE_PRIVATE_KEY
ARG NEXT_PUBLIC_GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET
ARG NEXT_PUBLIC_GOOGLE_OAUTH_REDIRECT_URI
ARG NEXT_PUBLIC_EMAILAPI_DOMAIN
ARG EMAILAPI_BASE_URL
ARG JSONBOX_NETWORK_URL
ARG MAILGUN_API_KEY
ARG MAILGUN_DOMAIN
ARG NEXT_PUBLIC_SENDING_EMAIL_ID
ARG MAILGUN_API_BASE_URL
ARG OTP_EMAILAPI_USER_ID
ARG NODE_DEBUG
ARG NODE_ENV
ARG SENTRY_DSN
ARG GOOGLE_SERVICE_ACCOUNT_EMAIL
ARG GOOGLE_PRIVATE_KEY
ARG REDISCLOUD_URL
RUN yarn build
EXPOSE 3000
CMD ["yarn", "start"]