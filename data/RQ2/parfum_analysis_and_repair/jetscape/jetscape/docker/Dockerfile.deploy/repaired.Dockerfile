FROM jetscape/base:v1.4

COPY --chown=jetscape-user:jetscape-user JETSCAPE-DOCKER /home/jetscape-user/JETSCAPE
RUN cd JETSCAPE/external_packages && \
	./get_music.sh && \
	./get_iSS.sh && \
	./get_freestream-milne.sh && \
	./get_smash.sh && \
	./get_lbtTab.sh && \
	cd .. && mkdir build && cd build && \
	cmake .. -DUSE_MUSIC=ON -DUSE_ISS=ON -DUSE_FREESTREAM=ON && make

RUN cd && mkdir bin && cd bin && ln -s ../JETSCAPE/build/runJetscape .
ENV PATH="${PATH}:${HOME}/bin"
RUN chmod -R 777 /home/jetscape-user/
RUN umask 000