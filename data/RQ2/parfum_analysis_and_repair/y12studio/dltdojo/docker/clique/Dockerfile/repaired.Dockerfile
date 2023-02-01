FROM dltdojo/geth:1.6.6
RUN apk --update --no-cache add tree
ADD build.sh info.sh start.sh ./
RUN chmod +x *.sh