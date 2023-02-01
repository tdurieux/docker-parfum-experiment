FROM node:alpine

WORKDIR /app
COPY ./package.json ./
RUN npm install
COPY . .


ENV MONGO_URL=mongodb+srv://pavan:pavan@shapeai.ujqaw.mongodb.net/zomato?retryWrites=true&w=majority
ENV GOOGLE_CLIENT_ID=448325328376-0noqmrddvmqm9lp1jin5c42jjna76ldc.apps.googleusercontent.com
ENV GOOGLE_CLIENT_SECRET=_ROue0E0m9cfiC6bLEJ6iMCz
ENV AWS_S3_ACCESS_KEY=AKIA2G4RARAPZOQ3EM2Y
ENV AWS_S3_SECRET_KEY=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
ENV MAILGUN__DOMAIN=sandbox2e5aaad8685c4527b9bbeee1eaed6ba4.mailgun.org
ENV MAILGUN__API__KEY=3d2c87739cfa7b9b0db054cdf6d60ea7-9776af14-eafee2c6
ENV RZR_PAY_ID=rzp_test_RNvW44vJHiXg1b
ENV RZR_PAY_SECRET=MHdAwlbdqlCJlFW4kKrbk4kT
ENV NODE_ENV=production
ENV PORT=4000

RUN npm run build


CMD ["npm", "run", "start"]