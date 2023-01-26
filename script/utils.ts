import { join } from "path";
import { Octokit, RestEndpointMethodTypes } from "@octokit/rest";
import { throttling } from "@octokit/plugin-throttling";
import { retry } from "@octokit/plugin-retry";
import { exec } from "child_process";

let MOctokit = Octokit.plugin(throttling);
MOctokit = MOctokit.plugin(retry);

import got from "got";
import * as fs from "fs";
import { Violation } from "@tdurieux/docker-parfum";
import { readFile } from "fs/promises";
import ProgressBar from "progress";
import async from "async";

import config from "../config";

interface RepositoryInfo {
  name: string;
  isFork: boolean;
  commits: number;
  branches: number;
  defaultBranch: string;
  releases: number;
  contributors: number;
  license: string;
  watchers: number;
  stargazers: number;
  forks: number;
  size: number;
  createdAt: string;
  pushedAt: string;
  updatedAt: string;
  homepage: string;
  mainLanguage: string;
  totalIssues: number;
  openIssues: number;
  totalPullRequests: number;
  openPullRequests: number;
  lastCommit: string;
  lastCommitSHA: string;
  hasWiki: boolean;
  isArchived: boolean;
}
type IterationArg = {
  repository: RepositoryInfo;
  violations: Violation[];
  owner: string;
  repo: string;
  path: string;
};

export async function iterateVulnerabilityAnalysis(
  callback: (arg: IterationArg) => Promise<void>,
  rootViolations = config.defaultRepairedDockerfileOutputPath,
  filter = (filename: string) => filename.endsWith("violations.json")
) {
  const repositories: any = {};
  (
    await readFile(config.defaultRepositoryListPath, {
      encoding: "utf-8",
    })
  )
    .split("\n")
    .forEach((line) => {
      const [
        name,
        isFork,
        commits,
        branches,
        defaultBranch,
        releases,
        contributors,
        license,
        watchers,
        stargazers,
        forks,
        size,
        createdAt,
        pushedAt,
        updatedAt,
        homepage,
        mainLanguage,
        totalIssues,
        openIssues,
        totalPullRequests,
        openPullRequests,
        lastCommit,
        lastCommitSHA,
        hasWiki,
        isArchived,
      ] = line.split(",");
      repositories[name] = {
        name,
        isFork,
        commits,
        branches,
        defaultBranch,
        releases,
        contributors,
        license,
        watchers,
        stargazers,
        forks,
        size,
        createdAt,
        pushedAt,
        updatedAt,
        homepage,
        mainLanguage,
        totalIssues,
        openIssues,
        totalPullRequests,
        openPullRequests,
        lastCommit,
        lastCommitSHA,
        hasWiki,
        isArchived,
      };
    });
  const violationsFiles = walkSync(rootViolations);
  violationsFiles.sort(() => (Math.random() > 0.5 ? 1 : -1));
  const bar = new ProgressBar(
    "[:bar] :current/:total :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: violationsFiles.length,
    }
  );

  return new Promise((resolve) => {
    async.forEachOfLimit(
      violationsFiles,
      3,
      async (path, index, asyncCallback) => {
        const splitPath = path.replace(rootViolations + "/", "").split("/");
        const owner = splitPath[0];
        const repo = splitPath[1];
        const filename = splitPath.slice(2).join("/").replace(".json", "");
        bar.tick({ step: `${owner}/${repo}` });
        if (!filter(path)) {
          return asyncCallback();
        }
        try {
          const violations = JSON.parse(
            await readFile(path, { encoding: "utf-8" })
          );
          await callback({
            repository: repositories[`${owner}/${repo}`],
            violations,
            owner,
            repo,
            path,
          });
        } catch (e) {
          console.error(e);
        } finally {
          asyncCallback();
        }
      },
      resolve
    );
  });
}

export function bytesToSize(bytes: number) {
  const sizes = ["Bytes", "KB", "MB", "GB", "TB"];
  if (bytes == 0) return "0 Byte";
  const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)).toString());
  return Math.round((bytes * 100) / Math.pow(1024, i)) / 100 + " " + sizes[i];
}

export function latexBytesToSize(bytes: number, precision = 2) {
  const sizes = ["Bytes", "KB", "MB", "GB", "TB", "PB"];
  if (bytes == 0) return "\\np[Byte]{0}";
  const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)).toString());
  return `\\np[${sizes[i]}]{${
    Math.round((bytes * Math.pow(10, precision)) / Math.pow(1024, i)) /
    Math.pow(10, precision)
  }}`;
}
export function latexPercent(
  value: number,
  total: number | void,
  precision = 2
) {
  return percent(value, total, precision).replace("%", "\\%");
}

export function percent(value: number, total: number | void, precision = 2) {
  if (!total)
    return (
      Math.round(value * 100 * Math.pow(10, precision)) /
        Math.pow(10, precision) +
      "%"
    );
  return (
    Math.round((value * 100 * Math.pow(10, precision)) / total) /
      Math.pow(10, precision) +
    "%"
  );
}

export function msToReadableTime(ms: number) {
  const seconds = Math.floor((ms / 1000) % 60);
  const minutes = Math.floor((ms / (1000 * 60)) % 60);
  const hours = Math.floor((ms / (1000 * 60 * 60)) % 24);
  const days = Math.floor(ms / (1000 * 60 * 60 * 24));

  let result = "";
  if (days > 0) result += days + "d ";
  if (hours > 0) result += hours + "h ";
  if (minutes > 0) result += minutes + "m ";
  if (seconds > 0) result += seconds + "s ";
  result += Math.round(ms % 1000) + "ms";
  return result.trim();
}

const tokens = {};
export function createOctokit(token: string) {
  const octokit = new MOctokit({
    auth: token,
    throttle: {
      onRateLimit: (retryAfter, options) => {
        octokit.log.warn(
          `Request quota exhausted for request ${options.method} ${options.url} ${options.headers.authorization}`
        );

        if (options.request.retryCount === 0) {
          // only retries once
          console.log(`Retrying after ${retryAfter} seconds!`);
          return true;
        }
      },
      onSecondaryRateLimit: (retryAfter, options, octokit) => {
        // does not retry, only logs a warning
        octokit.log.warn(
          `SecondaryRateLimit detected for request ${options.method} ${options.url}`
        );
      },
    },
  });
  octokit.hook.after("request", async (response, options) => {
    if (!tokens[token]) {
      tokens[token] = {};
    }
    tokens[token].remaining = parseInt(
      response.headers["x-ratelimit-remaining"] || "0"
    );
    tokens[token].reset = new Date(
      parseInt(response.headers["x-ratelimit-reset"] || "0") * 1000
    );
  });
  return octokit;
}
/**
 * Shuffles array in place.
 * @param {Array} a items An array containing the items.
 */
export function shuffle(a: Array<any>) {
  for (let i = a.length - 1; i > 0; i--) {
    let j = Math.floor(Math.random() * (i + 1));
    let x = a[i];
    a[i] = a[j];
    a[j] = x;
  }
  return a;
}

export async function walk(
  dir: string,
  callback: (path: string) => Promise<void> | void
) {
  for (const file of fs.readdirSync(dir)) {
    if (fs.statSync(join(dir, file)).isDirectory()) {
      await walk(join(dir, file), callback);
    } else {
      await callback(join(dir, file));
    }
  }
}

export function walkSync(dir: string, fileList: string[] = []) {
  fs.readdirSync(dir).forEach(function (file) {
    if (fs.statSync(join(dir, file)).isDirectory()) {
      fileList = walkSync(join(dir, file), fileList);
    } else {
      fileList.push(join(dir, file));
    }
  });
  return fileList;
}

export function clean_github_object(data: any) {
  if (typeof data == "object") {
    for (let key in data) {
      if (key.indexOf("_url") != -1 || data[key] == null) {
        delete data[key];
      }
      delete data._links;
      delete data.signature;
      data[key] = clean_github_object(data[key]);
    }
  } else if (Array.isArray(data)) {
    for (let i in data) {
      data[i] = clean_github_object(data[i]);
    }
  }
  return data;
}
export async function wait(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function downloadGithubRepository(
  repoName: string,
  token: string
) {
  const [owner, repo] = repoName.split("/");

  const octokit = createOctokit(token);
  const response = await octokit.repos.get({
    owner,
    repo,
  });
  return response.data;
}
export async function downloadGithubFile(
  repoName: string,
  commit: string,
  path: string,
  token: string
) {
  try {
    return (
      await got(
        "https://cdn.jsdelivr.net/gh/" + repoName + "@" + commit + "/" + path
      )
    ).body;
  } catch (error) {
    const owner = repoName.split("/")[0];
    const repo = repoName.split("/")[1];

    const octokit = createOctokit(token);
    type test = Extract<
      RestEndpointMethodTypes["repos"]["getContent"]["response"]["data"],
      { encoding: string }
    >;
    const response = await octokit.repos.getContent({
      owner,
      repo,
      path,
      ref: commit,
    });
    return Buffer.from(
      (response.data as test).content,
      (response.data as test).encoding as any
    ).toString("utf-8");
  }
}
/**
 * Execute command
 * @param cmd the command
 */
export function executeCommand(cmd: string): Promise<string> {
  return new Promise((resolve, reject) => {
    exec(cmd, (error, stdout, stderr) => {
      if (error && !stdout) {
        reject(error);
        return;
      }
      resolve(stdout.trim());
    });
  });
}

export function smellName(name: string) {
  name = name.replace(/^rule/, "");
  return name[0].toLowerCase() + name.slice(1);
}

export function smell2JSON(smell: Violation) {
  return {
    rule: smell.rule.name,
    position: {
      lineStart: smell.node.position.lineStart,
      lineEnd: smell.node.position.lineEnd,
      columnStart: smell.node.position.columnStart,
      columnEnd: smell.node.position.columnEnd,
    },
  };
}

interface JSONSmellResults {
  rule: string;
  position: {
    lineStart: number;
    lineEnd: number;
    columnStart: number;
    columnEnd: number;
  };
}

export async function readAnalsysiResults(path: string) {
  const info: {
    originalSmells: JSONSmellResults[];
    repairedSmells?: JSONSmellResults[];
    repairedDockerfile: string;
    startTime: number;
    endTime: number;
  } = JSON.parse(await readFile(path, "utf-8"));
  if ((info as any).repairedSmolls) {
    info.repairedSmells = (info as any).repairedSmolls;
  }
  return info;
}
