FROM voxxit/grunt:latest

WORKDIR /app

ONBUILD ADD package.json /app/
 \
RUN npm install && npm cache clean --force; ONBUILD
ONBUILD ADD bower.json /app/
ONBUILD RUN bower install --allow-root
ONBUILD ADD . /app

CMD [ "grunt" ]
