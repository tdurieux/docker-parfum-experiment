FROM bitsofinfo/cicd-toolbox:3.0.5

ARG GIT_TAG=master

RUN echo GIT_TAG=${GIT_TAG}

RUN pip3 -V

RUN found=1;while while [ $found -e; do sleep 5; x=$( curl -f -s https://pypi.org/simple/cicdstatemgr/ 2>&1 | grep $GIT_TAG) ; found=$?; echo "found? $found";done

RUN curl -f -s https://pypi.org/simple/cicdstatemgr/ 2>&1

RUN pip3 --no-cache-dir -vvv install cicdstatemgr==$GIT_TAG

RUN pip3 show cicdstatemgr

RUN cicdstatemgr -h

