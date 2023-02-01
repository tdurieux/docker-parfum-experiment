ARG BASE_IMAGE_REPO
ARG BASE_IMAGE_TAG
ARG CPU_BASE_IMAGE_NAME
ARG GPU_BASE_IMAGE_NAME
ARG LIGHTGBM_VERSION
ARG TORCH_VERSION
ARG TORCHAUDIO_VERSION
ARG TORCHTEXT_VERSION
ARG TORCHVISION_VERSION

{{ if eq .Accelerator "gpu" }}
FROM gcr.io/kaggle-images/python-lightgbm-whl:${GPU_BASE_IMAGE_NAME}-${BASE_IMAGE_TAG}-${LIGHTGBM_VERSION} AS lightgbm_whl
FROM gcr.io/kaggle-images/python-torch-whl:${GPU_BASE_IMAGE_NAME}-${BASE_IMAGE_TAG}-${TORCH_VERSION} AS torch_whl
FROM ${BASE_IMAGE_REPO}/${GPU_BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}
ARG CUDA_MAJOR_VERSION
ARG CUDA_MINOR_VERSION
ENV CUDA_MAJOR_VERSION=${CUDA_MAJOR_VERSION}
ENV CUDA_MINOR_VERSION=${CUDA_MINOR_VERSION}
# NVIDIA binaries from the host are mounted to /opt/bin.
ENV PATH=/opt/bin:${PATH}
# Add CUDA stubs to LD_LIBRARY_PATH to support building the GPU image on a CPU machine.
ENV LD_LIBRARY_PATH_NO_STUBS="$LD_LIBRARY_PATH"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64/stubs"
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
{{ else }}
FROM ${BASE_IMAGE_REPO}/${CPU_BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}
{{ end }}
# Keep these variables in sync if base image is updated.
ENV TENSORFLOW_VERSION=2.6.4

# We need to redefine the ARG here to get the ARG value defined above the FROM instruction.
# See: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG LIGHTGBM_VERSION
ARG TORCH_VERSION
ARG TORCHAUDIO_VERSION
ARG TORCHTEXT_VERSION
ARG TORCHVISION_VERSION

# Disable pesky logs like: KMP_AFFINITY: pid 6121 tid 6121 thread 0 bound to OS proc set 0
# See: https://stackoverflow.com/questions/57385766/disable-tensorflow-log-information
ENV KMP_WARNINGS=0
# Also make the KMP logs noverbose.
# https://stackoverflow.com/questions/70250304/stop-tensorflow-from-printing-warning-message
ENV KMP_SETTINGS=false

ADD clean-layer.sh  /tmp/clean-layer.sh
ADD patches/nbconvert-extensions.tpl /opt/kaggle/nbconvert-extensions.tpl
ADD patches/template_conf.json /opt/kaggle/conf.json

{{ if eq .Accelerator "gpu" }}
# b/200968891 Keeps horovod once torch is upgraded.
RUN pip uninstall -y horovod && \
    /tmp/clean-layer.sh
{{ end }}

# Use a fixed apt-get repo to stop intermittent failures due to flaky httpredir connections,
# as described by Lionel Chan at http://stackoverflow.com/a/37426929/5881346
RUN sed -i "s/httpredir.debian.org/debian.uchicago.edu/" /etc/apt/sources.list && \
    apt-get update && \
    # Needed by lightGBM (GPU build)
    # https://lightgbm.readthedocs.io/en/latest/GPU-Tutorial.html#build-lightgbm
    apt-get install --no-install-recommends -y build-essential unzip cmake libboost-dev libboost-system-dev libboost-filesystem-dev p7zip-full && \
    # b/182601974: ssh client was removed from the base image but is required for packages such as stable-baselines.
    apt-get install --no-install-recommends -y openssh-client && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

# b/128333086: Set PROJ_LIB to points to the proj4 cartographic library.
ENV PROJ_LIB=/opt/conda/share/proj

# Install conda packages not available on pip.
# When using pip in a conda environment, conda commands should be ran first and then
# the remaining pip commands: https://www.anaconda.com/using-pip-in-a-conda-environment/
RUN conda config --add channels nvidia && \
    conda config --add channels rapidsai && \
    # Base image channel order: conda-forge (highest priority), defaults.
    # End state: rapidsai (highest priority), nvidia, conda-forge, defaults.
    conda install mkl cartopy=0.19 imagemagick=7.1 pyproj==3.1.0 && \
    /tmp/clean-layer.sh

{{ if eq .Accelerator "gpu" }}

# b/232247930: uninstall pyarrow to avoid double installation with the GPU specific version.
RUN pip uninstall -y pyarrow && \
    conda install cudf=21.10 cuml=21.10 cudatoolkit=$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh
{{ end }}

# Install implicit
{{ if eq .Accelerator "gpu" }}
RUN conda install implicit implicit-proc=*=gpu && \
    /tmp/clean-layer.sh
{{ else }}
RUN conda install implicit && \
    /tmp/clean-layer.sh
{{ end}}

# Install PyTorch
{{ if eq .Accelerator "gpu" }}
COPY --from=torch_whl /tmp/whl/*.whl /tmp/torch/
RUN conda install -c pytorch magma-cuda${CUDA_MAJOR_VERSION}${CUDA_MINOR_VERSION} && \
    pip install --no-cache-dir /tmp/torch/*.whl && \
    rm -rf /tmp/torch && \
    /tmp/clean-layer.sh
{{ else }}
RUN pip install --no-cache-dir torch==$TORCH_VERSION+cpu torchvision==$TORCHVISION_VERSION+cpu torchaudio==$TORCHAUDIO_VERSION+cpu torchtext==$TORCHTEXT_VERSION -f https://download.pytorch.org/whl/torch_stable.html && \
    /tmp/clean-layer.sh
{{ end }}

# Install LightGBM
{{ if eq .Accelerator "gpu" }}
COPY --from=lightgbm_whl /tmp/whl/*.whl /tmp/lightgbm/
# Install OpenCL (required by LightGBM GPU version)
RUN apt-get install --no-install-recommends -y ocl-icd-libopencl1 clinfo && \
    mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
    pip install --no-cache-dir /tmp/lightgbm/*.whl && \
    rm -rf /tmp/lightgbm && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;
{{ else }}
RUN pip install --no-cache-dir lightgbm==$LIGHTGBM_VERSION && \
    /tmp/clean-layer.sh
{{ end }}

# Install JAX
{{ if eq .Accelerator "gpu" }}
RUN pip install --no-cache-dir jax[cuda11_cudnn805] -f https://storage.googleapis.com/jax-releases/jax_releases.html && \
    /tmp/clean-layer.sh
{{ else }}
RUN pip install --no-cache-dir jax[cpu] && \
    /tmp/clean-layer.sh
{{ end }}

# Install mxnet
{{ if eq .Accelerator "gpu" }}
RUN pip install --no-cache-dir mxnet-cu$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh
{{ else }}
RUN pip install --no-cache-dir mxnet && \
    /tmp/clean-layer.sh
{{ end}}

# Install spacy
{{ if eq .Accelerator "gpu" }}
RUN pip install --no-cache-dir spacy[cuda$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION] && \
    /tmp/clean-layer.sh
{{ else }}
RUN pip install --no-cache-dir spacy && \
    /tmp/clean-layer.sh
{{ end}}

# Install GPU specific packages
{{ if eq .Accelerator "gpu" }}
# Install GPU-only packages
RUN pip install --no-cache-dir pycuda && \
    pip install --no-cache-dir pynvrtc && \
    pip install --no-cache-dir pynvml && \
    pip install --no-cache-dir nnabla-ext-cuda$CUDA_MAJOR_VERSION$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh
{{ end }}

RUN pip install --no-cache-dir pysal && \
    pip install --no-cache-dir seaborn python-dateutil dask python-igraph && \
    pip install --no-cache-dir pyyaml joblib husl geopy mne pyshp && \
    pip install --no-cache-dir pandas && \
    pip install --no-cache-dir flax && \
    # Install h2o from source.
    # Use `conda install -c h2oai h2o` once Python 3.7 version is released to conda.
    apt-get install --no-install-recommends -y default-jre-headless && \
    pip install --no-cache-dir -f https://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o && \
    pip install --no-cache-dir tensorflow-gcs-config==2.6.0 && \
    pip install --no-cache-dir tensorflow-addons==0.14.0 && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libfreetype6-dev && \
    apt-get install --no-install-recommends -y libglib2.0-0 libxext6 libsm6 libxrender1 libfontconfig1 --fix-missing && \
    # b/198300835 kornia 4.1.0 is not compatible with our version of numpy.
    pip install --no-cache-dir gensim==4.0.1 && \
    pip install --no-cache-dir textblob && \
    pip install --no-cache-dir wordcloud && \
    pip install --no-cache-dir xgboost && \
    pip install --no-cache-dir pydot && \
    # Pinned because it breaks theano test with the latest version (b/178107003).
    pip install --no-cache-dir theano-pymc==1.0.11 && \
    pip install --no-cache-dir python-Levenshtein && \
    pip install --no-cache-dir hep_ml && \
    # NLTK Project datasets
    mkdir -p /usr/share/nltk_data && \
    # NLTK Downloader no longer continues smoothly after an error, so we explicitly list
    # the corpuses that work
    # "yes | ..." answers yes to the retry prompt in case of an error. See b/133762095.
    yes | python -m nltk.downloader -d /usr/share/nltk_data abc alpino averaged_perceptron_tagger \
    basque_grammars biocreative_ppi bllip_wsj_no_aux \
    book_grammars brown brown_tei cess_cat cess_esp chat80 city_database cmudict \
    comtrans conll2000 conll2002 conll2007 crubadan dependency_treebank \
    europarl_raw floresta gazetteers genesis gutenberg \
    ieer inaugural indian jeita kimmo knbc large_grammars lin_thesaurus mac_morpho machado \
    masc_tagged maxent_ne_chunker maxent_treebank_pos_tagger moses_sample movie_reviews \
    mte_teip5 names nps_chat omw opinion_lexicon paradigms \
    pil pl196x porter_test ppattach problem_reports product_reviews_1 product_reviews_2 propbank \
    pros_cons ptb punkt qc reuters rslp rte sample_grammars semcor senseval sentence_polarity \
    sentiwordnet shakespeare sinica_treebank smultron snowball_data spanish_grammars \
    state_union stopwords subjectivity swadesh switchboard tagsets timit toolbox treebank \
    twitter_samples udhr2 udhr unicode_samples universal_tagset universal_treebanks_v20 \
    vader_lexicon verbnet webtext word2vec_sample wordnet wordnet_ic words ycoe && \
    # Stop-words
    pip install --no-cache-dir stop-words && \
    pip install --no-cache-dir scikit-image && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir ibis-framework && \
    pip install --no-cache-dir gluonnlp && \
    # b/212703016 4.5.4.62 segfault with readtext.
    pip install --no-cache-dir opencv-contrib-python==4.5.4.60 opencv-python==4.5.4.60 && \
    pip install --no-cache-dir gluoncv && \
    /tmp/clean-layer.sh

RUN pip install --no-cache-dir scipy && \
    pip install --no-cache-dir scikit-learn && \
    # Scikit-learn accelerated library for x86
    pip install --no-cache-dir scikit-learn-intelex && \
    # HDF5 support
    pip install --no-cache-dir h5py && \
    pip install --no-cache-dir biopython && \
    # PUDB, for local debugging convenience
    pip install --no-cache-dir pudb && \
    pip install --no-cache-dir imbalanced-learn && \
    # Profiling and other utilities
    pip install --no-cache-dir line_profiler && \
    pip install --no-cache-dir orderedmultidict && \
    pip install --no-cache-dir smhasher && \
    pip install --no-cache-dir bokeh && \
    pip install --no-cache-dir numba && \
    pip install --no-cache-dir datashader && \
    # Boruta (python implementation)
    pip install --no-cache-dir Boruta && \
    apt-get install --no-install-recommends -y graphviz && pip install --no-cache-dir graphviz && \
    # Pandoc is a dependency of deap
    apt-get install --no-install-recommends -y pandoc && \
    pip install --no-cache-dir git+https://github.com/scikit-learn-contrib/py-earth.git@issue191 && \
    pip install --no-cache-dir essentia && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

# vtk with dependencies
RUN apt-get install --no-install-recommends -y libgl1-mesa-glx && \
    pip install --no-cache-dir vtk && \
    # xvfbwrapper with dependencies
    apt-get install --no-install-recommends -y xvfb && \
    pip install --no-cache-dir xvfbwrapper && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir mpld3 && \
    pip install --no-cache-dir gpxpy && \
    pip install --no-cache-dir arrow && \
    pip install --no-cache-dir nilearn && \
    pip install --no-cache-dir nibabel && \
    pip install --no-cache-dir pronouncing && \
    pip install --no-cache-dir markovify && \
    pip install --no-cache-dir imgaug && \
    pip install --no-cache-dir preprocessing && \
    pip install --no-cache-dir path.py && \
    pip install --no-cache-dir Geohash && \
    # https://github.com/vinsci/geohash/issues/4
    sed -i -- 's/geohash/.geohash/g' /opt/conda/lib/python3.7/site-packages/Geohash/__init__.py && \
    pip install --no-cache-dir deap && \
    pip install --no-cache-dir tpot && \
    pip install --no-cache-dir scikit-optimize && \
    pip install --no-cache-dir haversine && \
    pip install --no-cache-dir toolz cytoolz && \
    pip install --no-cache-dir plotly && \
    pip install --no-cache-dir hyperopt && \
    pip install --no-cache-dir fitter && \
    pip install --no-cache-dir langid && \
    # Delorean. Useful for dealing with datetime
    pip install --no-cache-dir delorean && \
    pip install --no-cache-dir trueskill && \
    # Useful data exploration libraries (for missing data and generating reports)
    pip install --no-cache-dir missingno && \
    pip install --no-cache-dir pandas-profiling && \
    pip install --no-cache-dir s2sphere && \
    pip install --no-cache-dir bayesian-optimization && \
    pip install --no-cache-dir matplotlib-venn && \
    # b/184083722 pyldavis >= 3.3 requires numpy >= 1.20.0 but TensorFlow 2.4.1 / 2.5.0 requires 1.19.2
    pip install --no-cache-dir pyldavis==3.2.2 && \
    pip install --no-cache-dir mlxtend && \
    pip install --no-cache-dir altair && \
    pip install --no-cache-dir ImageHash && \
    pip install --no-cache-dir ecos && \
    pip install --no-cache-dir CVXcanon && \
    pip install --no-cache-dir pymc3 && \
    pip install --no-cache-dir imagecodecs && \
    pip install --no-cache-dir tifffile && \
    pip install --no-cache-dir spectral && \
    pip install --no-cache-dir descartes && \
    pip install --no-cache-dir geojson && \
    pip install --no-cache-dir pydicom && \
    pip install --no-cache-dir wavio && \
    pip install --no-cache-dir SimpleITK && \
    pip install --no-cache-dir hmmlearn && \
    pip install --no-cache-dir bayespy && \
    pip install --no-cache-dir gplearn && \
    pip install --no-cache-dir PyAstronomy && \
    pip install --no-cache-dir squarify && \
    pip install --no-cache-dir fuzzywuzzy && \
    pip install --no-cache-dir python-louvain && \
    pip install --no-cache-dir pyexcel-ods && \
    pip install --no-cache-dir sklearn-pandas && \
    pip install --no-cache-dir stemming && \
    pip install --no-cache-dir prophet && \
    pip install --no-cache-dir holoviews && \
    pip install --no-cache-dir geoviews && \
    pip install --no-cache-dir hypertools && \
    pip install --no-cache-dir py_stringsimjoin && \
    pip install --no-cache-dir mlens && \
    pip install --no-cache-dir scikit-multilearn && \
    pip install --no-cache-dir cleverhans && \
    pip install --no-cache-dir leven && \
    pip install --no-cache-dir catboost && \
    pip install --no-cache-dir lightfm && \
    pip install --no-cache-dir folium && \
    pip install --no-cache-dir scikit-plot && \
    pip install --no-cache-dir fury dipy && \
    pip install --no-cache-dir plotnine && \
    pip install --no-cache-dir scikit-surprise && \
    pip install --no-cache-dir pymongo && \
    pip install --no-cache-dir geoplot && \
    pip install --no-cache-dir eli5 && \
    pip install --no-cache-dir kaggle && \
    /tmp/clean-layer.sh

RUN pip install --no-cache-dir tensorpack && \
    # Add google PAIR-code Facets
    cd /opt/ && git clone https://github.com/PAIR-code/facets && cd facets/ && jupyter nbextension install facets-dist/ --user && \
    export PYTHONPATH=$PYTHONPATH:/opt/facets/facets_overview/python/ && \
    pip install --no-cache-dir pycountry && \
    pip install --no-cache-dir iso3166 && \
    pip install --no-cache-dir pydash && \
    pip install --no-cache-dir kmodes --no-dependencies && \
    pip install --no-cache-dir librosa && \
    pip install --no-cache-dir polyglot && \
    pip install --no-cache-dir mmh3 && \
    pip install --no-cache-dir fbpca && \
    pip install --no-cache-dir sentencepiece && \
    pip install --no-cache-dir cufflinks && \
    pip install --no-cache-dir lime && \
    pip install --no-cache-dir memory_profiler && \
    /tmp/clean-layer.sh

# install cython & cysignals before pyfasttext
RUN pip install --no-cache-dir --upgrade cython && \
    pip install --no-cache-dir --upgrade cysignals && \
    pip install --no-cache-dir pyfasttext && \
    pip install --no-cache-dir fasttext && \
    apt-get install --no-install-recommends -y libhunspell-dev && pip install --no-cache-dir hunspell && \
    pip install --no-cache-dir annoy && \
    pip install --no-cache-dir category_encoders && \
    # google-cloud-automl 2.0.0 introduced incompatible API changes, need to pin to 1.0.1
    pip install --no-cache-dir google-cloud-automl==1.0.1 && \
    pip install --no-cache-dir google-cloud-bigquery==2.2.0 && \
    pip install --no-cache-dir google-cloud-storage && \
    pip install --no-cache-dir google-cloud-translate==3.* && \
    pip install --no-cache-dir google-cloud-language==2.* && \
    pip install --no-cache-dir google-cloud-videointelligence==2.* && \
    pip install --no-cache-dir google-cloud-vision==2.* && \
    # b/183041606#comment5: the Kaggle data proxy doesn't support these APIs. If the library is missing, it falls back to using a regular BigQuery query to fetch data.
    pip uninstall -y google-cloud-bigquery-storage && \
    # After launch this should be installed from pip
    pip install --no-cache-dir git+https://github.com/googleapis/python-aiplatform.git@mb-release && \
    pip install --no-cache-dir ortools && \
    pip install --no-cache-dir scattertext && \
    # Pandas data reader
    pip install --no-cache-dir pandas-datareader && \
    pip install --no-cache-dir wordsegment && \
    pip install --no-cache-dir wordbatch && \
    pip install --no-cache-dir emoji && \
    # Add Japanese morphological analysis engine
    pip install --no-cache-dir janome && \
    pip install --no-cache-dir wfdb && \
    pip install --no-cache-dir vecstack && \
    # yellowbrick machine learning visualization library
    pip install --no-cache-dir yellowbrick && \
    pip install --no-cache-dir mlcrate && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir bleach && \
    pip install --no-cache-dir certifi && \
    pip install --no-cache-dir cycler && \
    pip install --no-cache-dir decorator && \
    pip install --no-cache-dir entrypoints && \
    pip install --no-cache-dir html5lib && \
    pip install --no-cache-dir ipykernel && \
    pip install --no-cache-dir ipython && \
    pip install --no-cache-dir ipython-genutils && \
    pip install --no-cache-dir ipywidgets && \
    pip install --no-cache-dir isoweek && \
    pip install --no-cache-dir jedi && \
    pip install --no-cache-dir jsonschema && \
    pip install --no-cache-dir jupyter-client && \
    pip install --no-cache-dir jupyter-console && \
    pip install --no-cache-dir jupyter-core && \
    pip install --no-cache-dir jupyterlab-lsp && \
    pip install --no-cache-dir MarkupSafe && \
    pip install --no-cache-dir mistune && \
    pip install --no-cache-dir nbformat && \
    pip install --no-cache-dir notebook && \
    pip install --no-cache-dir papermill && \
    pip install --no-cache-dir python-lsp-server[all] && \
    pip install --no-cache-dir olefile && \
    # b/198300835 kornia 0.5.10 is not compatible with our version of numpy.
    pip install --no-cache-dir kornia==0.5.8 && \
    pip install --no-cache-dir pandas_summary && \
    pip install --no-cache-dir pandocfilters && \
    pip install --no-cache-dir pexpect && \
    pip install --no-cache-dir pickleshare && \
    pip install --no-cache-dir Pillow && \
    # Install openslide and its python binding
    apt-get install --no-install-recommends -y openslide-tools && \
    pip install --no-cache-dir openslide-python && \
    pip install --no-cache-dir ptyprocess && \
    pip install --no-cache-dir Pygments && \
    pip install --no-cache-dir pyparsing && \
    pip install --no-cache-dir pytz && \
    pip install --no-cache-dir PyYAML && \
    pip install --no-cache-dir pyzmq && \
    pip install --no-cache-dir qtconsole && \
    pip install --no-cache-dir six && \
    pip install --no-cache-dir terminado && \
    pip install --no-cache-dir tornado && \
    pip install --no-cache-dir tqdm && \
    pip install --no-cache-dir traitlets && \
    pip install --no-cache-dir wcwidth && \
    pip install --no-cache-dir webencodings && \
    pip install --no-cache-dir widgetsnbextension && \
    pip install --no-cache-dir pyarrow && \
    pip install --no-cache-dir feather-format && \
    pip install --no-cache-dir fastai && \
    pip install --no-cache-dir allennlp && \
    pip install --no-cache-dir importlib-metadata && \
    python -m spacy download en_core_web_sm && python -m spacy download en_core_web_lg && \
    apt-get install --no-install-recommends -y ffmpeg && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

    ###########
    #
    #      NEW CONTRIBUTORS:
    # Please add new pip/apt installs in this block. Don't forget a "&& \" at the end
    # of all non-final lines. Thanks!
    #
    ###########

RUN pip install --no-cache-dir flashtext && \
    pip install --no-cache-dir wandb && \
    # b/214080882 blake3 0.3.0 is not compatible with vaex.
    pip install --no-cache-dir blake3==0.2.1 && \
    pip install --no-cache-dir vaex && \
    pip install --no-cache-dir marisa-trie && \
    pip install --no-cache-dir pyemd && \
    pip install --no-cache-dir pyupset && \
    pip install --no-cache-dir pympler && \
    pip install --no-cache-dir s3fs && \
    pip install --no-cache-dir featuretools && \
    pip install --no-cache-dir -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper && \
    pip install --no-cache-dir hpsklearn && \
    pip install --no-cache-dir git+https://github.com/Kaggle/learntools && \
    pip install --no-cache-dir kmapper && \
    pip install --no-cache-dir shap && \
    pip install --no-cache-dir ray && \
    pip install --no-cache-dir gym && \
    pip install --no-cache-dir pyarabic && \
    pip install --no-cache-dir pandasql && \
    pip install --no-cache-dir tensorflow_hub && \
    pip install --no-cache-dir jieba && \
    pip install --no-cache-dir git+https://github.com/SauceCat/PDPbox && \
    # ggplot is broken and main repo does not merge and release https://github.com/yhat/ggpy/pull/668
    pip install --no-cache-dir https://github.com/hbasria/ggpy/archive/0.11.5.zip && \
    pip install --no-cache-dir cesium && \
    pip install --no-cache-dir rgf_python && \
    # b/205704651 remove install cmd for matrixprofile after version > 1.1.10 is released.
    pip install --no-cache-dir git+https://github.com/matrix-profile-foundation/matrixprofile.git@6bea7d4445284dbd9700a097974ef6d4613fbca7 && \
    pip install --no-cache-dir tsfresh && \
    pip install --no-cache-dir pykalman && \
    pip install --no-cache-dir optuna && \
    pip install --no-cache-dir plotly_express && \
    pip install --no-cache-dir albumentations && \
    pip install --no-cache-dir catalyst && \
    # b/206990323 osmx 1.1.2 requires numpy >= 1.21 which we don't want.
    pip install --no-cache-dir osmnx==1.1.1 && \
    apt-get -y --no-install-recommends install libspatialindex-dev && \
    pip install --no-cache-dir pytorch-ignite && \
    pip install --no-cache-dir qgrid && \
    pip install --no-cache-dir bqplot && \
    pip install --no-cache-dir earthengine-api && \
    pip install --no-cache-dir transformers && \
    # b/232247930 >= 2.2.0 requires pyarrow >= 6.0.0 which conflicts with dependencies for rapidsai 0.21.*
    pip install --no-cache-dir datasets==2.1.0 && \
    pip install --no-cache-dir dlib && \
    pip install --no-cache-dir kaggle-environments && \
    pip install --no-cache-dir geopandas && \
    pip install --no-cache-dir nnabla && \
    pip install --no-cache-dir vowpalwabbit && \
    pip install --no-cache-dir pydub && \
    pip install --no-cache-dir pydegensac && \
    pip install --no-cache-dir torchmetrics && \
    pip install --no-cache-dir pytorch-lightning && \
    pip install --no-cache-dir datatable && \
    pip install --no-cache-dir sympy && \
    # flask is used by agents in the simulation competitions.
    pip install --no-cache-dir flask && \
    # pycrypto is used by competitions team.
    pip install --no-cache-dir pycrypto && \
    pip install --no-cache-dir easyocr && \
    # ipympl adds interactive widget support for matplotlib
    pip install --no-cache-dir ipympl==0.7.0 && \
    pip install --no-cache-dir pandarallel && \
    pip install --no-cache-dir onnx && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;

# Download base easyocr models.
# https://github.com/JaidedAI/EasyOCR#usage
RUN mkdir -p /root/.EasyOCR/model && \
    wget --no-verbose "https://github.com/JaidedAI/EasyOCR/releases/download/v1.3/latin_g2.zip" -O /root/.EasyOCR/model/latin.zip && \
    unzip /root/.EasyOCR/model/latin.zip -d /root/.EasyOCR/model/ && \
    rm /root/.EasyOCR/model/latin.zip && \
    wget --no-verbose "https://github.com/JaidedAI/EasyOCR/releases/download/v1.3/english_g2.zip" -O /root/.EasyOCR/model/english.zip && \
    unzip /root/.EasyOCR/model/english.zip -d /root/.EasyOCR/model/ && \
    rm /root/.EasyOCR/model/english.zip && \
    wget --no-verbose "https://github.com/JaidedAI/EasyOCR/releases/download/pre-v1.1.6/craft_mlt_25k.zip" -O /root/.EasyOCR/model/craft_mlt_25k.zip && \
    unzip /root/.EasyOCR/model/craft_mlt_25k.zip -d /root/.EasyOCR/model/ && \
    rm /root/.EasyOCR/model/craft_mlt_25k.zip && \
    /tmp/clean-layer.sh

# Tesseract and some associated utility packages
RUN apt-get install --no-install-recommends tesseract-ocr -y && \
    pip install --no-cache-dir pytesseract && \
    pip install --no-cache-dir wand && \
    pip install --no-cache-dir pdf2image && \
    pip install --no-cache-dir PyPDF && \
    pip install --no-cache-dir pyocr && \
    /tmp/clean-layer.sh && rm -rf /var/lib/apt/lists/*;
ENV TESSERACT_PATH=/usr/bin/tesseract

# For Facets
ENV PYTHONPATH=$PYTHONPATH:/opt/facets/facets_overview/python/
# For Theano with MKL
ENV MKL_THREADING_LAYER=GNU

# Temporary fixes and patches
# Temporary patch for Dask getting downgraded, which breaks Keras
RUN pip install --no-cache-dir --upgrade dask && \
    # Stop jupyter nbconvert trying to rewrite its folder hierarchy
    mkdir -p /root/.jupyter && touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated && \
    mkdir -p /.jupyter && touch /.jupyter/jupyter_nbconvert_config.py && touch /.jupyter/migrated && \
    # Stop Matplotlib printing junk to the console on first load
    sed -i "s/^.*Matplotlib is building the font cache using fc-list.*$/# Warning removed by Kaggle/g" /opt/conda/lib/python3.7/site-packages/matplotlib/font_manager.py && \
    # Make matplotlib output in Jupyter notebooks display correctly
    mkdir -p /etc/ipython/ && echo "c = get_config(); c.IPKernelApp.matplotlib = 'inline'" > /etc/ipython/ipython_config.py && \
    # Temporary patch for broken libpixman 0.38 in conda-forge, symlink to system libpixman 0.34 untile conda package gets updated to 0.38.5 or higher.
    ln -sf /usr/lib/x86_64-linux-gnu/libpixman-1.so.0.34.0 /opt/conda/lib/libpixman-1.so.0.38.0 && \
    /tmp/clean-layer.sh

# Add BigQuery client proxy settings
ENV PYTHONUSERBASE "/root/.local"
ADD patches/kaggle_gcp.py /root/.local/lib/python3.7/site-packages/kaggle_gcp.py
ADD patches/kaggle_secrets.py /root/.local/lib/python3.7/site-packages/kaggle_secrets.py
ADD patches/kaggle_session.py /root/.local/lib/python3.7/site-packages/kaggle_session.py
ADD patches/kaggle_web_client.py /root/.local/lib/python3.7/site-packages/kaggle_web_client.py
ADD patches/kaggle_datasets.py /root/.local/lib/python3.7/site-packages/kaggle_datasets.py
ADD patches/log.py /root/.local/lib/python3.7/site-packages/log.py
ADD patches/sitecustomize.py /root/.local/lib/python3.7/site-packages/sitecustomize.py
# Override default imagemagick policies
ADD patches/imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

# TensorBoard Jupyter extension. Should be replaced with TensorBoard's provided magic once we have
# worker tunneling support in place.
# b/139212522 re-enable TensorBoard once solution for slowdown is implemented.
# ENV JUPYTER_CONFIG_DIR "/root/.jupyter/"
# RUN pip install jupyter_tensorboard && \
#     jupyter serverextension enable jupyter_tensorboard && \
#     jupyter tensorboard enable
# ADD patches/tensorboard/notebook.py /opt/conda/lib/python3.7/site-packages/tensorboard/notebook.py

# Disable unnecessary jupyter extensions
RUN jupyter-nbextension disable nb_conda --py --sys-prefix && \
    jupyter-serverextension disable nb_conda --py --sys-prefix && \
    python -m nb_conda_kernels.install --disable

# Set backend for matplotlib
ENV MPLBACKEND "agg"

ARG GIT_COMMIT=unknown
ARG BUILD_DATE=unknown

LABEL git-commit=$GIT_COMMIT
LABEL build-date=$BUILD_DATE
ENV GIT_COMMIT=${GIT_COMMIT}
ENV BUILD_DATE=${BUILD_DATE}

LABEL tensorflow-version=$TENSORFLOW_VERSION
# Used in the Jenkins `Docker GPU Build` step to restrict the images being pruned.
LABEL kaggle-lang=python

# Correlate current release with the git hash inside the kernel editor by running `!cat /etc/git_commit`.
RUN echo "$GIT_COMMIT" > /etc/git_commit && echo "$BUILD_DATE" > /etc/build_date

{{ if eq .Accelerator "gpu" }}
# Remove the CUDA stubs.
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH_NO_STUBS"
{{ end }}
