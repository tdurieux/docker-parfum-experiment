import { join } from "path";

const dataFolder = join(__dirname, "data");
const datasetFolder = join(__dirname, "datasets");
const docsFolder = join(__dirname, "docs");
const config = {
  github_tokens: [],
  dataFolder,
  datasetFolder,
  docsFolder,
  defaultRepositoryListPath: join(dataFolder, "dataset/repositories.csv"),
  defaultBinnacleAnalysisAndRepairPath: join(
    dataFolder,
    "rq1/binnacle_analysis_and_repair"
  ),
  defaultFileListOutputPath: join(
    dataFolder,
    "dataset/pafum/repository_file_list"
  ),
  groundTrustDockerfiles: join(datasetFolder, "ground-truth/dockerfiles"),
  groundTrusts: join(datasetFolder, "ground-truth/smells"),
  defaultDockerfileOutputPath: join(datasetFolder, "parfum"),
  defaultRepairedDockerfileOutputPath: join(
    dataFolder,
    "rq2/parfum_analysis_and_repair"
  ),
  defaultBuildDockerfileOutputPath: join(
    dataFolder,
    "RQ2-RQ3/build_anaysis_and_repair"
  ),
};

export default config;
