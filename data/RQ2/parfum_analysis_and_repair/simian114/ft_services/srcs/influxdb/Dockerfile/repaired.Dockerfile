FROM alpine:latest

RUN apk add influxdb --no-cache

EXPOSE 8086

# mkdir -p /run/influxd 를 만들고
# ENTRYPOINT ["influxd"] 실행하는거랑 같음.
# 지금 보면 influxdb에 관해서 어떤 설정도 하지 않고 서버를 바로 시작하는걸 확인할 수 있다.
# 흠.. 그러면 DB의 이름이나 user, password 등은 어떻게 되는거지?
# 전역 변수로 해결할 수 있다.
# influxdb environment variables 등의 키워드로 구글검색하면 된다.
# 데이터베이스 서버는 보통 전역변수로 하는게 일반적인거 같음.
ENTRYPOINT ["/usr/sbin/influxd"]