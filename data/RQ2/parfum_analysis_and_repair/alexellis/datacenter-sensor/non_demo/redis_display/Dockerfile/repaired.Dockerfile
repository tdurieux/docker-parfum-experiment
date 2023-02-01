from alexellis2/node4.x-arm:v6

add package.json ./
run npm i && npm cache clean --force;

add app.js ./
EXPOSE 9000
cmd ["node", "app.js"]
