"""Known upstream templ release checksums."""

# Releases are available at https://github.com/a-h/templ/releases.
# URL format is platform-dependent, e.g.
# https://github.com/a-h/templ/releases/download/v0.3.960/templ_Linux_x86_64.tar.gz
TEMPL_VERSIONS = {
    "0.3.960": {
        "go_sum": "h1:trshEpGa8clF5cdI39iY4ZrZG8Z/QixyzEyUnA7feTM=",
        "linux_amd64": "354705b095164480d1e2ed0b5c83c7914b3156319a855dadb28cbf9d97dbd92f",
    },
}

PLATFORMS = {
    "linux_amd64": struct(os_name = "linux", arch = "amd64", release_os = "Linux", release_arch = "x86_64"),
    "linux_arm64": struct(os_name = "linux", arch = "arm64", release_os = "Linux", release_arch = "arm64"),
    "darwin_amd64": struct(os_name = "mac os x", arch = "amd64", release_os = "Darwin", release_arch = "x86_64"),
    "darwin_arm64": struct(os_name = "mac os x", arch = "arm64", release_os = "Darwin", release_arch = "arm64"),
}
