FROM public.ecr.aws/amazonlinux/amazonlinux:latest

RUN yum upgrade -y && yum install -y bash && rm -rf /var/cache/yum

COPY logscript.sh /

CMD ["bash", "/logscript.sh"]
