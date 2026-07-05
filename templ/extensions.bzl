"""Bzlmod extension for hermetic templ binaries."""

load(":repositories.bzl", "templ_register_tool")

_DEFAULT_NAME = "templ"

_tool_tag = tag_class(attrs = {
    "name": attr.string(
        default = _DEFAULT_NAME,
        doc = "Repository name for this templ binary. Non-default names are only allowed in the root module.",
    ),
    "templ_version": attr.string(
        mandatory = True,
        doc = "Templ release version, without the leading v, for example 0.3.960.",
    ),
    "sha256s": attr.string_dict(
        default = {},
        doc = "Optional platform->sha256 overrides, e.g. {\"linux_amd64\": \"...\"}.",
    ),
    "platform": attr.string(
        default = "auto",
        doc = "Host platform to download, or auto. Mostly intended for tests.",
    ),
    "go_repository_name": attr.string(
        default = "",
        doc = "Repository name for the matching github.com/a-h/templ Go library. Defaults to com_github_a_h_templ or <name>_go.",
    ),
})


def _select_tool(name, registrations):
    selected = registrations[0]
    versions = []

    for registration in registrations:
        versions.append(registration.templ_version)
        # TODO: make this semver-aware. This mirrors rules_sqlc's simple
        # lexicographic selection and is sufficient for current templ versions.
        if registration.templ_version > selected.templ_version:
            selected = registration

    if len(registrations) > 1:
        # buildifier: disable=print
        print("NOTE: templ tool {} has multiple versions {}, selected {}".format(
            name,
            versions,
            selected.templ_version,
        ))

    return selected


def _templ_extension_impl(module_ctx):
    registrations = {}

    for mod in module_ctx.modules:
        for tool in mod.tags.tool:
            if tool.name != _DEFAULT_NAME and not mod.is_root:
                fail("Only the root module may register non-default templ tool names.")
            registrations.setdefault(tool.name, []).append(tool)

    for name, tools in registrations.items():
        selected = _select_tool(name, tools)
        templ_register_tool(
            name = name,
            go_repository_name = selected.go_repository_name or None,
            templ_version = selected.templ_version,
            sha256s = selected.sha256s,
            platform = selected.platform,
        )


templ = module_extension(
    implementation = _templ_extension_impl,
    tag_classes = {"tool": _tool_tag},
)
