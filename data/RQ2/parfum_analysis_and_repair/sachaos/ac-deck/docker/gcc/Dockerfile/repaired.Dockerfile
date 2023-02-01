FROM gcc:9.2

RUN apt-get update -y && apt-get upgrade -y

RUN curl -f -Lo boost.tar.gz https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.gz
RUN mkdir -p /opt/boost/
RUN tar xvzf boost.tar.gz -C /opt/boost && rm boost.tar.gz

RUN curl -f -Lo ac-library.zip https://img.atcoder.jp/practice2/ac-library.zip
RUN unzip ac-library -d /opt/ac-library
RUN rm ac-library.zip
RUN rm -rf /opt/ac-library/document_en /opt/ac-library/document_ja /opt/ac-library/expander.py

CMD ["bash"]
