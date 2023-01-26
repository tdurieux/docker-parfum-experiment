import { mkdir, readFile, writeFile } from "fs/promises";
import { existsSync } from "fs";
import { dirname, join } from "path";

import Yargs from "yargs/yargs";
import * as dockerhub from "docker-hub-api";
import { eachLimit } from "async";

import { downloadGithubRepository, wait } from "../utils";
import config from "../../config";
import { RepositoryAnalysisResult } from "../3.RQ2/repair_repository_dockerfile";

async function main() {
  const argv = await Yargs(process.argv.slice(2))
    .option("repositories", {
      type: "string",
      demandOption: true,
      alias: "r",
    })
    .option("process", {
      type: "number",
      demandOption: false,
      default: 4,
      alias: "p",
    })
    .option("token", {
      type: "string",
      demandOption: false,
      default: process.env.GITHUB_TOKEN,
      alias: "t",
    })
    .option("dockerhub-username", {
      type: "string",
      demandOption: false,
      default: process.env.DOCKERHUB_USERNAME,
      alias: "u",
    })
    .option("dockerhub-password", {
      type: "string",
      demandOption: false,
      default: process.env.DOCKERHUB_PASSWORD,
      alias: "p",
    })
    .parse();
  // const dockerhubLogin = await dockerhub.login(
  //   argv.dockerhubUsername,
  //   argv.dockerhubPassword
  // );

  const repositoryList = (
    await readFile(argv.repositories, { encoding: "utf-8" })
  ).split("\n");
  const organizations = new Set<string>();
  let count = 0;
  eachLimit(repositoryList, argv.process, async (repositoryLine, callback) => {
    const [repositoryUrl, dockerfilePath] = repositoryLine
      .split(",")
      .slice(0, 2);
    const [owner, repo] = repositoryUrl
      .replace(".git", "")
      .split("/")
      .slice(-2);

    const dockerhubInfoPath = join(
      config.dataFolder,
      "evaluation/dockerhub_info",
      `${owner}-${repo}.json`
    );
    let hubImage = undefined;
    if (existsSync(dockerhubInfoPath)) {
      hubImage = JSON.parse(await readFile(dockerhubInfoPath, "utf-8"));
      if (hubImage.detail == "Rate limit exceeded") {
        hubImage = undefined;
      }
    }
    if (!hubImage) {
      try {
        hubImage = await dockerhub.repository(owner, repo);
        if (hubImage.detail == "Rate limit exceeded") {
          await wait(1000);
        }
        if (!existsSync(dirname(dockerhubInfoPath))) {
          await mkdir(dirname(dockerhubInfoPath), { recursive: true });
        }
        await writeFile(dockerhubInfoPath, JSON.stringify(hubImage, null, 2));
      } catch (error) {
        console.error(error);
        return callback();
      }
    }

    const repoInfoPath = join(
      config.dataFolder,
      "evaluation/repository_info",
      `${owner}-${repo}.json`
    );

    let repoInfo: Awaited<ReturnType<typeof downloadGithubRepository>> =
      undefined;
    if (existsSync(repoInfoPath)) {
      repoInfo = JSON.parse(await readFile(repoInfoPath, "utf-8"));
    } else {
      try {
        repoInfo = await downloadGithubRepository(
          `${owner}/${repo}`,
          argv.token
        );
        if (!existsSync(dirname(repoInfoPath))) {
          await mkdir(dirname(repoInfoPath), { recursive: true });
        }
        await writeFile(repoInfoPath, JSON.stringify(repoInfo, null, 2));
      } catch (error) {
        // console.error(error);
        return callback();
      }
    }

    const repairInfoPath = join(
      config.defaultBuildDockerfileOutputPath,
      `${owner}/${repo}.json`
    );
    let repairInfo: RepositoryAnalysisResult = undefined;
    if (existsSync(repairInfoPath)) {
      repairInfo = JSON.parse(await readFile(repairInfoPath, "utf-8"));
    }
    const oneMonthAgo = new Date();
    oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
    const lastYear = new Date();
    lastYear.setFullYear(lastYear.getFullYear() - 1);
    if (
      new Date(repoInfo.pushed_at) > oneMonthAgo &&
      !repoInfo.archived &&
      !repoInfo.disabled &&
      !repoInfo.fork &&
      repoInfo.has_issues &&
      repoInfo.network_count > 1 &&
      !organizations.has(owner) &&
      !hubImage.errinfo &&
      hubImage.pull_count > 1000 &&
      hubImage.repository_type == "image" &&
      hubImage.status_description == "active" &&
      new Date(hubImage.last_updated) > lastYear &&
      repairInfo &&
      repairInfo.repair.violations.length > 0 &&
      repairInfo.repair.violations.length < 10 &&
      repairInfo.repairedBuild?.imageSize !== undefined &&
      repairInfo.originalBuild.imageSize - repairInfo.repairedBuild.imageSize >
        1024
    ) {
      organizations.add(owner);
      console.log(
        `${++count},https://github.com/${owner}/${repo},${dockerfilePath},${
          repoInfo.pushed_at
        },${repoInfo.stargazers_count},${repoInfo.network_count},${
          repairInfo.repair.violations.length
        },${repairInfo.originalBuild.imageSize},${
          repairInfo.repairedBuild.imageSize
        }`
      );
    }
    callback();
  });
}
if (require.main === module) {
  main();
}
