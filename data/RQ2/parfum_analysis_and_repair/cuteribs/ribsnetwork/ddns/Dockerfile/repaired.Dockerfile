#
# Dockerfile for ddns
#

FROM cuteribs/alpine
LABEL maintainer="cuteribs <ericfine1981@live.com>"

COPY ./*.sh /app/

WORKDIR /app/

#ENV Time="* 6 * * *"
#ENV Script="dnspod"
#ENV ApiId="123456789"
#ENV ApiKey="f7c3bc1d808e04732adf679965ccc34ca7ae3441"
#ENV Domain="example.com"
#ENV SubDomain="www"