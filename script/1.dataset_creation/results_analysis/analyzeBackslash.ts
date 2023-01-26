import lzma from "lzma-native";
import tar from "tar-stream";
import fs from "fs";
import { join } from "path";
import config from "../../../config";

(async () => {
  let count = 0;
  return new Promise<void>((resolve) => {
    const extract = tar.extract();

    const results = {};
    extract.on("entry", function (header, stream, next) {
      console.log(++count);
      let fileContent = "";
      stream.on("end", async function () {
        try {
          const m = fileContent.match(/([^\n]+)(\\[^\\])([^\n]+)/gm);
          if (m) {
            for (const context of m) {
              const keys = context.match(/\\([^\\])/gm);
              // if (
              //   ![
              //     "\\\n",
              //     "\\n",
              //     "\\\s",
              //     "\\\d",
              //     "\\\.",
              //     "\\\t",
              //     "\\\r",
              //     "\\ ",
              //     '\\"',
              //     "\\;",
              //     "\\)",
              //     "\\(",
              //     "\\{",
              //     "\\}",
              //   ].includes(key)
              // ) {
              //   const context = fileContent.match(
              //     new RegExp("([^\n]+)" + key + "([^\n]+)", "gm")
              //   );
              //   console.log(key, context);
              // }
              if (
                context.includes("C:\\") ||
                context.match(
                  /(?<ParentPath>(?:[a-zA-Z]\:|\\\\[\w\s\.]+\\[\w\s\.$]+)\\(?:[\w\s\.]+\\)*)(?<BaseName>[\w\s\.]*?)/gim
                )
              ) {
                results["PATH"] = results["PATH"] ? results["PATH"] + 1 : 1;
              } else if (keys)
                for (const key of keys) {
                  results[key] = results[key] ? results[key] + 1 : 1;
                }
            }
          }
        } catch (error) {
          console.log(error);
        } finally {
          next();
        }
      });
      stream.on("data", (d: Buffer) => {
        fileContent += d.toString("utf-8");
      });
    });

    extract.on("finish", function () {
      // all entries done - lets finalize it
      console.log(JSON.stringify(results, null, 2));
    });
    fs.createReadStream(join(config.dataFolder, "github.tar.xz"))
      .pipe(lzma.createDecompressor())
      .pipe(extract)
      .on("finish", () => resolve());
  });
})();
