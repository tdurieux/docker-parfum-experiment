# keep our base image as small as possible
FROM docker.io/nginx/unit:1.27.0-node16
# Alternatively, you can download the base image from AWS ECR:
# FROM public.ecr.aws/nginx/unit:1.27.0-node16

# port used by the listener in config.json
EXPOSE 8080

#application setup
RUN mkdir /www/ && echo '#!/usr/bin/env node                             \n\
    require("unit-http").createServer(function (req, res) {                \
        res.writeHead(200, {"Content-Type": "text/plain"});                \
        res.end("Hello, Node.js on Unit!")                                 \
    }).listen()                                                            \
    ' > /www/app.js                                                        \
# make app.js executable; link unit-http locally
    && cd /www && chmod +x app.js                                          \
    && npm link unit-http                                                  \
# prepare the app config for Unit