"""Executable wrapper rule for downloaded templ binaries."""


def _templ_binary_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(
        output = executable,
        target_file = ctx.file.binary,
        is_executable = True,
    )
    return [DefaultInfo(
        executable = executable,
        files = depset([executable]),
        runfiles = ctx.runfiles(files = [ctx.file.binary]),
    )]


templ_binary = rule(
    implementation = _templ_binary_impl,
    attrs = {
        "binary": attr.label(allow_single_file = True, mandatory = True),
    },
    executable = True,
)
