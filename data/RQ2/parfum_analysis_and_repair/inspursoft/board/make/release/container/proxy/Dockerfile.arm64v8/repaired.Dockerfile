FROM arm64v8/nginx:1.15.7-alpine
MAINTAINER huay@inspur.com 

COPY src/ui/dist /usr/share/nginx/html