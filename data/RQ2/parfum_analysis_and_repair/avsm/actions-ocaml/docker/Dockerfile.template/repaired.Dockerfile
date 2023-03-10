FROM %%BASE_IMG%%
COPY . /home/opam/src
RUN sudo chown -R opam /home/opam/src
RUN git -C /home/opam/opam-repository pull && opam update -uy
RUN opam pin add /home/opam/src -n
RUN opam depext %%PKGS%%
RUN opam install /home/opam/src --deps-only
RUN opam pin remove %%PKGS%% -n
RUN rm -rf /home/opam/src