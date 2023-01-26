import { readFile, readdir } from "fs/promises";
import { join } from "path";
import { RepositoryAnalysisResult } from "../repair_repository_dockerfile";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { smellName } from "../../utils";

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      alias: "p",
      description: "The path to the repository analysis results",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .parse();

  const owners = await readdir(argv.resultPath);
  const errors: { [key: string]: number } = {};
  const totalRepair: { [key: string]: number } = {};
  let countBuildError = 0;
  let countBuildableDockerfile = 0;
  let countBuildedDockerfile = 0;
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      const path = join(argv.resultPath, owner, repoFile);
      const results: RepositoryAnalysisResult = JSON.parse(
        await readFile(path, "utf-8")
      );
      countBuildedDockerfile++;
      if (results.originalBuild.error || !results.repairedBuild) continue;
      new Set(results.repair.violations.map((v) => smellName(v.name))).forEach(
        (v) => {
          totalRepair[v] = totalRepair[v] + 1 || 1;
        }
      );
      countBuildableDockerfile++;
      // results.repair.violations
      //   .map((v) => smellName(v.name))
      //   .forEach((v) => {
      //     totalRepair[v] = totalRepair[v] + 1 || 1;
      //   });
      if (!results.repairedBuild.error) continue;
      const buildResult = results.repairedBuild;

      if (
        buildResult.error &&
        buildResult.error.code === "ERR_CHILD_PROCESS_STDIO_MAXBUFFER"
      ) {
        continue;
      }
      new Set(results.repair.violations.map((v) => smellName(v.name))).forEach(
        (v) => {
          errors[v] = errors[v] + 1 || 1;
        }
      );
      countBuildError++;
      // results.repair.violations
      //   .map((v) => v.name.replace(/^rule/, "").toLowerCase())
      //   .forEach((v) => {
      //     errors[v] = errors[v] + 1 || 1;
      //   });
    }
  }
  for (const rule of Object.keys(errors).sort(
    (a, b) => errors[b] - errors[a]
  )) {
    console.log(`${rule} & \\percent{${errors[rule]}}{\\countBuildError} \\\\`);
  }

  console.log("");
  console.log(`\\def\\countBuildError{${countBuildError}}`);
  console.log(`\\def\\countBuildableDockerfile{${countBuildableDockerfile}}`);
  console.log(`\\def\\countBuildedDockerfile{${countBuildedDockerfile}}`);
})();
