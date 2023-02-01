FROM node

RUN npm install -g parse-dashboard@1.0.7 && npm cache clean --force;

WORKDIR /dashboard

ENTRYPOINT ["parse-dashboard"]

EXPOSE 4040

CMD ["-h"]