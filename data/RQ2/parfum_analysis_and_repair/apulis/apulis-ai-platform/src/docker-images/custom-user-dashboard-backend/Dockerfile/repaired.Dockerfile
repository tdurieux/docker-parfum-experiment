FROM node:12

RUN mkdir -p /home/addon_custom_user_dasboard_backend
WORKDIR /home/addon_custom_user_dasboard_backend
RUN git clone --branch release-0.1.6 https://gitee.com/apulis/user-dashboard-backend.git  /home/addon_custom_user_dasboard_backend
RUN yarn config set registry 'https://registry.npm.taobao.org' && yarn cache clean;
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 5001

CMD ["yarn", "start:prod"]
