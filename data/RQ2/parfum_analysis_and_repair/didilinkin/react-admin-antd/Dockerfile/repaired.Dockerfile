FROM node

RUN mkdir /runtime
WORKDIR /runtime

RUN npm init -y

#install gulp for auto build
RUN npm install --save-dev gulp gulp-uglify; npm cache clean --force;
RUN npm install --save-dev del; npm cache clean --force;
RUN npm install --save-dev vinyl-source-stream; npm cache clean --force;
RUN npm install --save-dev browserify; npm cache clean --force;
RUN npm install --save-dev reactify; npm cache clean --force;
RUN npm install --save-dev react react-dom; npm cache clean --force;


#install react and build tool
#RUN npm install -g browserify
#RUN npm install --save-dev react react-dom babelify babel-preset-react

#add gulpfile
ADD . /runtime

CMD ["bash", "run.sh"]
