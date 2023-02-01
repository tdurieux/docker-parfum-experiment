FROM gitpod/workspace-full

USER root

RUN apt-get -yq update \
	&& apt-get install --no-install-recommends -yq gcc-8 g++-8 \
	&& apt-get install --no-install-recommends -yq clang-8 \
	&& apt-get install --no-install-recommends -yq valgrind \
	&& apt-get install --no-install-recommends -yq libboost-all-dev \
	&& apt-get install --no-install-recommends -yq asciidoctor \
	&& apt-get install --no-install-recommends -yq libcurl4-gnutls-dev \
	&& apt-get install --no-install-recommends -yq doxygen \
	&& apt-get install --no-install-recommends -yq texlive-latex-base \
	&& apt-get install --no-install-recommends -yq texlive-fonts-recommended \
	&& apt-get install --no-install-recommends -yq texlive-fonts-extra \
	&& apt-get install --no-install-recommends -yq texlive-latex-extra \
	&& apt-get install --no-install-recommends -yq graphviz \
	&& apt-get install --no-install-recommends -yq clang-tidy-8 \
	&& apt-get install --no-install-recommends -yq lcov \
	&& apt-get install --no-install-recommends -yq ninja-build \
	&& apt-get install --no-install-recommends -yq libsfml-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
