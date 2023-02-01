FROM clintsharp/gogen:latest
ADD gogen /etc/gogen
ENV GOGEN_CONFIG_DIR /etc/gogen
ENV GOGEN_ADDTIME false
ENV GOGEN_DEBUG false