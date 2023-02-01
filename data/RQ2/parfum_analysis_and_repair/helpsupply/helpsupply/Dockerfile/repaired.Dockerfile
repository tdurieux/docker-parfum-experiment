FROM node:buster
RUN npm install -g firebase-tools && npm cache clean --force;
RUN firebase setup:emulators:firestore

RUN apt-get update && apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

COPY firebase.json .
CMD firebase emulators:start --only firestore

