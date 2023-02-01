#
# szepeviktor/stretch-backport
#
# VERSION       :0.1.0
# BUILD         :docker build -t szepeviktor/stretch-backport .
# RUN           :docker run --rm --tty -v $TARGET_PATH:/opt/results --env PACKAGE="$SOURCE-PACKAGE/$RELEASE" szepeviktor/stretch-backport