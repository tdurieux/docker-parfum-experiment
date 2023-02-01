FROM ubuntu

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    erlang-dev \
    erlang-nox \
    make \
    wget \
    redir && rm -rf /var/lib/apt/lists/*;

ADD install_tsung.sh /install_tsung.sh
ADD start_redir.sh /start_redir.sh
RUN /install_tsung.sh
CMD /start_redir.sh

EXPOSE 80