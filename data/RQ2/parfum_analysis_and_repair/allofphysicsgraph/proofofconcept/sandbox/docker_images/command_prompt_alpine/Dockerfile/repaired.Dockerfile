# 20180602

FROM python:2.7-alpine

MAINTAINER My Name <my.email.address@gmail.com>

LABEL distro_style="apk" distro="alpine" arch="x86_64" operatingsystem="linux"

# for graph visualization
RUN apk add --update --no-cache graphviz
# for compiling Latex to PDF
RUN apk add --update --no-cache texlive-full
RUN apk add --update --no-cache texlive
# zlib and jpg required for pillow
RUN apk add --update --no-cache zlib-dev zlib
RUN apk add --update --no-cache jpeg-dev
# gcc is needed to build pillow
RUN apk add --update --no-cache build-base
# web server
#https://wiki.alpinelinux.org/wiki/Lighttpd
RUN apk add --update --no-cache lighttpd lighttpd-mod_auth
#https://wiki.alpinelinux.org/wiki/Nginx
RUN apk add --update --no-cache nginx

# for reading configuration file
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir sympy
RUN pip install --no-cache-dir pillow

RUN mkdir /derivations
RUN mkdir /inference_rules

#RUN apk add --no-cache curl
#RUN git clone https://github.com/allofphysicsgraph/proofofconcept.git

ADD v4_file_per_expression/interactive_user_prompt.py interactive_user_prompt.py
ADD lib/lib_physics_graph.py /lib/lib_physics_graph.py
ADD v4_file_per_expression/inference_rules/* /inference_rules/

# web server
EXPOSE 80

#WORKDIR /bin

CMD ["python", "interactive_user_prompt.py"]
