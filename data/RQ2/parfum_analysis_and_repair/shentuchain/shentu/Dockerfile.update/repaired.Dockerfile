FROM shentu-base

RUN rm -rf /shentu
ADD . /shentu
WORKDIR /shentu

RUN make install
EXPOSE 26656 26657 26658
CMD ["certik"]