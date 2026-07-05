# rules_templ

Small Bazel ruleset for [templ](https://github.com/a-h/templ).

## Bzlmod setup

```bzl
bazel_dep(name = "rules_templ", version = "...")

templ = use_extension("@rules_templ//templ:extensions.bzl", "templ")
templ.tool(templ_version = "0.3.960")
use_repo(templ, "templ", "com_github_a_h_templ")
```

Multiple templ binaries can be registered by name from the root module:

```bzl
templ.tool(name = "templ_old", templ_version = "0.3.960")
use_repo(templ, "templ", "com_github_a_h_templ", "templ_old", "templ_old_go")
```

Unknown platform checksums can be provided explicitly:

```bzl
templ.tool(
    templ_version = "0.3.960",
    sha256s = {"linux_arm64": "..."},
)
```

## Usage

```bzl
load("@rules_templ//templ:defs.bzl", "templ_library")

templ_library(
    name = "views",
    srcs = ["layout.templ"],
    importpath = "example.com/project/views",
    deps = ["//core"],
)
```

`templ_library` runs the hermetic `@templ//:bin` binary and wraps the generated `*_templ.go` files in a `go_library`.
The generated Go code depends on `github.com/a-h/templ`; the extension exposes the version-aligned Go module as `@com_github_a_h_templ`, matching Gazelle's conventional repository name.
