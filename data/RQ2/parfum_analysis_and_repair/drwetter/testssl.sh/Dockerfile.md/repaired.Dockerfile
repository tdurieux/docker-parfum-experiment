## Usage

### From git directory

```
docker build .
```

Catch is when you run without image tags you need to catch the ID when building

```
[..]
---> 889fa2f99933
Successfully built 889fa2f99933
```

More comfortable is

```
docker build -t mytestssl .
docker run --rm -t mytestssl example.com
```

You can also supply command line options like:

```
docker run -t mytestssl --help
docker run --rm -t mytestssl -p --header example.com
```

### From dockerhub