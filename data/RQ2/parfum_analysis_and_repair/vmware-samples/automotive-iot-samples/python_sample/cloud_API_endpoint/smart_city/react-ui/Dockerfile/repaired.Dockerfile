FROM node:10.9.0

COPY . .

# install dependencies
RUN yarn && yarn cache clean;

# build app
RUN yarn build && yarn cache clean;

RUN yarn global add serve && yarn cache clean;

CMD serve -s build -l 4002


#############
# Build:
# $ docker build -t insurance_ui:0.1 .
# Run:
# $ docker run -it --rm -p 5000:5000 insurance_ui:0.1
