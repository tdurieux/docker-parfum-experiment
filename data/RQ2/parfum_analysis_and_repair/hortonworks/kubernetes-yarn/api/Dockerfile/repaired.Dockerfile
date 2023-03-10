FROM google/nodejs
RUN npm i -g raml2html && npm cache clean --force;
ADD . /data
CMD ["-i", "/data/kubernetes.raml", "-o", "/data/kubernetes.html"]
ENTRYPOINT ["raml2html"]
