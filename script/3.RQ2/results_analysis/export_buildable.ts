import { readFile, readdir } from "fs/promises";
import { join } from "path";
import { RepositoryAnalysisResult } from "../repair_repository_dockerfile";
import config from "../../../config";
import Yargs from "yargs/yargs";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .parse();

  const owners = await readdir(argv.resultPath);
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      const results: RepositoryAnalysisResult = JSON.parse(
        await readFile(join(argv.resultPath, owner, repoFile), "utf-8")
      );
      if (results.originalBuild.error) continue;
      console.log(`${results.repository},${results.dockerfilePath}`);
    }
  }
})();
