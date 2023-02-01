FROM node:12.18.1

RUN apt-get update


#INSTALL CHROME
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update -y
RUN apt-get install --no-install-recommends google-chrome-stable -yqq && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && npm cache clean --force;
ENV FLAG FLAGNOTVALID{Solve_My_Challenge}
COPY . .
CMD ["npm", "start"]
