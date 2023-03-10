# vim: ft=dockerfile:

FROM registry.cn-beijing.aliyuncs.com/lovego/service

LABEL builder=xiaomei

RUN mkdir {{ .ProName }}
WORKDIR {{ .ProName }}

COPY {{ .ProName }} ./
COPY config ./config
RUN mkdir ./log

RUN sudo chmod 775 {{ .ProName }} \
 && sudo find config -type d -exec chmod 775 {} \+ \
 && sudo find config -type f -exec chmod 664 {} \+

CMD [ "./{{ .ProName }}" ]