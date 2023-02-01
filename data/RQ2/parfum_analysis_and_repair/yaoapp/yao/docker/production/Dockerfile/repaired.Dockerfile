# ===========================================
#  Yao Production
#  docker build \
#    --build-arg VERSION="${VERSION}"  \
#    --build-arg ARCH="${ARCH}"  \
#    -t yaoapp/yao-dev:${VERSION}-${ARCH} .
#
#  Build:
#  docker build --platform linux/amd64 --build-arg VERSION=0.9.1 --build-arg ARCH=amd64 -t yaoapp/yao:0.9.1-amd64 .
#  docker build --platform linux/arm64 --build-arg VERSION=0.9.1 --build-arg ARCH=arm64 -t yaoapp/yao:0.9.1-arm64 .
#
#  Tests:
#  docker run --rm yaoapp/yao:0.9.1-amd64 yao version
#  docker run -d -p 5099:5099 yaoapp/yao:0.9.1-amd64
#
# ===========================================