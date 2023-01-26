import { readFile, readdir } from "fs/promises";
import { join } from "path";
import { RepositoryAnalysisResult } from "../repair_repository_dockerfile";
import Yargs from "yargs/yargs";
import config from "../../../config";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      alias: "p",
      description: "The path to the repository analysis results",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .option("repaired", {
      type: "boolean",
      alias: "r",
      description: "Whether to show errors in the repaired builds",
    })
    .parse();

  const owners = await readdir(argv.resultPath);
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      const path = join(argv.resultPath, owner, repoFile);
      const results: RepositoryAnalysisResult = JSON.parse(
        await readFile(path, "utf-8")
      );
      if (argv.repaired) {
        if (results.originalBuild.error || !results.repairedBuild) continue;
        if (!results.repairedBuild.error) continue;
      } else {
        if (!results.originalBuild.error) continue;
      }
      console.log(`${results.repository},${results.dockerfilePath}`);
    }
  }
})();
