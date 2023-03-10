FROM xappbase

RUN apt-get install --no-install-recommends -yq chromium && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["chromium"]
CMD ["--no-sandbox"]

RUN mkdir /.config/
RUN mkdir /.pki/
RUN chown dockerx:users /.config/
RUN chown dockerx:users /.pki/
RUN chmod 777 /.config
RUN chmod 777 /.pki
#USER dockerx
VOLUME ["/.config", "/.pki"]
