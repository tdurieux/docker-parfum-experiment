import { mkdir, readFile, writeFile } from "fs/promises";
import { existsSync } from "fs";
import { join, dirname, basename } from "path";
import ProgressBar from "progress";
import async from "async";
import Yargs from "yargs/yargs";

import config from "../../config";
import * as utils from "../utils";

const tokens = {};
for (let token of config.github_tokens) {
  tokens[token] = {};
}
async function downloadDockerfiles(
  repoFilePath: string,
  token: string,
  outputPath: string
) {
  const [owner, repo] = repoFilePath.replace(".json", "").split("/").slice(-2);
  if (!owner || !repo) return;

  const files = JSON.parse(await readFile(repoFilePath, "utf-8")) as {
    tree: {
      path: string;
      mode: string;
      type: string;
      sha: string;
      size: number;
    }[];
    sha: string;
  };
  for (const file of files.tree.filter(
    (f) =>
      f.type == "blob" &&
      f.path.includes("Dockerfile") &&
      !f.path.includes("test") &&
      !f.path.includes("resources")
  )) {
    const parentDir = join(outputPath, dirname(file.path));

    const content = await utils.downloadGithubFile(
      `${owner}/${repo}`,
      files.sha,
      file.path,
      token
    );

    if (!existsSync(parentDir)) {
      await mkdir(parentDir, { recursive: true });
    }

    await writeFile(join(parentDir, basename(file.path)), content, "utf-8");
  }
}
(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("fileListPath", {
      type: "string",
      default: config.defaultFileListOutputPath,
    })
    .option("output", {
      type: "string",
      default: config.defaultDockerfileOutputPath,
      alias: "o",
    })
    .option("skip-existing", {
      type: "boolean",
      default: true,
      alias: "s",
      description: "Skip repositories that have their Dockerfiles downloaded",
    })
    .parse();

  if (config.github_tokens.length == 0) {
    throw new Error(
      "No github token available, the tokens need to be provided in the config file (./config.ts)"
    );
  }

  const repoFileLists = utils.walkSync(argv.fileListPath);

  const bar = new ProgressBar(
    "[:bar] :current/:total :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: repoFileLists.length,
    }
  );
  const available_tokens = [...config.github_tokens];

  async.eachOfLimit(
    repoFileLists,
    available_tokens.length,
    async (repoFilePath, _, callback) => {
      const [owner, repo] = repoFilePath
        .replace(".json", "")
        .split("/")
        .slice(-2);

      bar.tick({ step: `${owner}/${repo}` });
      if (!owner || !repo) return callback();

      const filePath = join(argv.output, `${owner}/${repo}`);

      if (argv.skipExisting && existsSync(filePath)) return callback();

      const token = available_tokens.pop();
      if (!token) {
        throw new Error("No token available");
      }

      try {
        await downloadDockerfiles(repoFilePath, token, filePath);
      } catch (error) {
        console.log(error);
      } finally {
        available_tokens.push(token);
        callback();
      }
    }
  );
})();
