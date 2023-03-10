FROM python:3.8-slim-buster

# https://portal.nersc.gov/cfs/m2650/metatlas/test_data
# serves from /global/cfs/cdirs/m2650/www/metatlas/test_data
ARG BASE_DATA_URL=https://portal.nersc.gov/cfs/m2650/metatlas/test_data/ci02
ARG REFS_DIR=/global/cfs/cdirs/metatlas/projects/spectral_libraries
ARG H5_DIR=/global/cfs/cdirs/metatlas/raw_data/akuftin/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583

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
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_FPS_MS1_0_QC_Post_Rg70to1050-CE102040--QC_Run307.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_FPS_MS1_0_QC_Pre_Rg70to1050-CE102040--QC_Run6.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_0_QC_Post_Rg70to1050-CE102040--QC_Run309.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_0_QC_Pre_Rg70to1050-CE102040--QC_Run8.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_0_QC_Post_Rg70to1050-CE102040--QC_Run308.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_0_QC_Pre_Rg70to1050-CE102040--QC_Run7.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_53_Cone-S1_5_Rg70to1050-CE102040-QlobataAkingi-S1_Run188.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_57_Cone-S2_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run41.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_58_Cone-S2_2_Rg70to1050-CE102040-QlobataAkingi-S1_Run56.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_NEG_MSMS_59_Cone-S2_3_Rg70to1050-CE102040-QlobataAkingi-S1_Run87.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_49_Cone-S1_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run34.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_53_Cone-S1_5_Rg70to1050-CE102040-QlobataAkingi-S1_Run187.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_54_Cone-S1_6_Rg70to1050-CE102040-QlobataAkingi-S1_Run221.h5 $H5_DIR/
ADD $BASE_DATA_URL/20201106_JGI-AK_PS-KM_505892_OakGall_final_QE-HF_HILICZ_USHXG01583_POS_MSMS_57_Cone-S2_1_Rg70to1050-CE102040-QlobataAkingi-S1_Run40.h5 $H5_DIR/

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir --quiet -r requirements.txt

ADD $BASE_DATA_URL/meta_atlas_rt_predict.sqlite3 /work/root_workspace.db

RUN mkdir -p /root/.local/share/jupyter/kernels/papermill
COPY papermill.kernel.json /root/.local/share/jupyter/kernels/papermill/kernel.json

RUN echo "1" > /metatlas_image_version

WORKDIR /work

ENV METATLAS_TEST=True
ENV PYTHONPATH=/src

CMD ["/usr/local/bin/jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--ServerApp.token=''", "--ServerApp.root_dir=/"]
