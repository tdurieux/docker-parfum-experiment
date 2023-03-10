FROM azul/zulu-openjdk:11

ENV mango_paths_home=/opt/mango
ENV mango_paths_data=/opt/mango-data
WORKDIR "$mango_paths_home"
EXPOSE 8080
ENV CLASSPATH="$mango_paths_home/lib/*"
ENTRYPOINT ["java"]
CMD ["com.serotonin.m2m2.Main"]

ARG BUNDLE_ZIP
COPY ${BUNDLE_ZIP} mango-bundle.zip
RUN jar xf mango-bundle.zip && \
rm mango-bundle.zip && \
cd web/modules && \
for f in *.zip; do tmp=${f#m2m2-}; name=${tmp%%-*}; mkdir $name; cd $name; jar xf ../$f; cd ..; rm $f; done