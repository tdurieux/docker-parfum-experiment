FROM node:14.16
RUN yarn global add gatsby-cli gatsby gatsby-theme-carbon && yarn cache clean;
EXPOSE 8000
WORKDIR /home
CMD ["bash"]
