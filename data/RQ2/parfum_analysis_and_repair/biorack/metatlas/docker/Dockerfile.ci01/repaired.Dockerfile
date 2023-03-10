FROM python:3.8-slim-bullseye

# https://portal.nersc.gov/cfs/m2650/metatlas/test_data
# serves from /global/cfs/cdirs/m2650/www/metatlas/test_data
ARG BASE_DATA_URL=https://portal.nersc.gov/cfs/m2650/metatlas/test_data/ci01
ARG REFS_DIR=/global/cfs/cdirs/metatlas/projects/spectral_libraries
ARG H5_DIR=/global/cfs/cdirs/metatlas/raw_data/akuftin/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583
ARG NOTES_DIR=/global/cfs/cdirs/m2650/targeted_analysis/

ENV METATLAS_LOCAL=True

EXPOSE 8888

RUN apt-get update && apt-get install --no-install-recommends -y \
        libxrender1 \
	git \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

RUN mkdir -p /io /src /work $REFS_DIR $H5_DIR

ADD $BASE_DATA_URL/msms_refs_v3.tab $REFS_DIR/

ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_49_Cone-S1_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run34.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_57_Cone-S2_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run40.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_65_Cone-S3_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run16.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_73_Cone-S4_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run31.h5 $H5_DIR/

# also get the mzML files, as these are used in matchms within add_msms_refs
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_49_Cone-S1_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run34.mzML $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_57_Cone-S2_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run40.mzML $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_65_Cone-S3_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run16.mzML $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_73_Cone-S4_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run31.mzML $H5_DIR/

ADD $BASE_DATA_URL/meta_atlas.sqlite3 /work/root_workspace.db

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --quiet -r requirements.txt

ADD $BASE_DATA_URL/instructions_for_analysts.csv $NOTES_DIR/

RUN mkdir -p /root/.local/share/jupyter/kernels/papermill
COPY papermill.kernel.json /root/.local/share/jupyter/kernels/papermill/kernel.json

RUN echo "1" > /metatlas_image_version

WORKDIR /work

ENV METATLAS_TEST=True
ENV PYTHONPATH=/src

CMD ["/usr/local/bin/jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--ServerApp.token=''", "--ServerApp.root_dir=/"]
