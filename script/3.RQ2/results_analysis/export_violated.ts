import { Violation } from "@tdurieux/docker-parfum";
import { readFile } from "fs/promises";
import { iterateVulnerabilityAnalysis } from "../../utils";
import yargs from "yargs";
import config from "../../../config";

(async () => {
  // console.log(
  //   `url,dockerfile_path,nb_original_violations,nb_repaired_violations`
  // );
  const argv = await yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: config.defaultRepairedDockerfileOutputPath,
    })
    .option("only-root", {
      type: "boolean",
      demandOption: false,
      alias: "r",
      description: "Only consider root Dockerfile",
    })
    .parse();
  await iterateVulnerabilityAnalysis(
    async (analysis) => {
      if (!analysis.repository) return;

      const originalAnalisis: Violation[] = JSON.parse(
        await readFile(
          analysis.path.replace("repaired_violations.json", "violations.json"),
          "utf-8"
        )
      );

      if (originalAnalisis.length == 0) return;

      const path = analysis.path
        .replace(`${argv.resultPath}/${analysis.owner}/${analysis.repo}/`, "")
        .replace("/repaired_violations.json", "");

      if (argv.onlyRoot && path != "Dockerfile") return;

      console.log(
        `https://github.com/${analysis.owner}/${analysis.repo},${path},${originalAnalisis.length},${analysis.violations.length}`
      );
    },
    argv.resultPath,
    (path) => path.endsWith("repaired_violations.json")
  );
})();
