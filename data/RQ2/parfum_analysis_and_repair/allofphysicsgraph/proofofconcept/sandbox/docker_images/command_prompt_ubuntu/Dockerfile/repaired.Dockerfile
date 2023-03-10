# 20180602

FROM ubuntu:18.04

MAINTAINER My Name <my.email.address@gmail.com>

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    python-pip \
    python2.7 \
    graphviz && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir sympy

RUN mkdir /derivations
RUN mkdir /inference_rules

ADD ./v4_file_per_expression/bin/interactive_user_prompt.py interactive_user_prompt.py
ADD ./v4_file_per_expression/lib/lib_physics_graph.py /lib/lib_physics_graph.py
ADD ./v4_file_per_expression/inference_rules/* /inference_rules/

#WORKDIR /bin
#ENTRYPOINT ["/usr/bin/python2.7"]

CMD ["python", "interactive_user_prompt.py"]


