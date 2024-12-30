const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "z",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(b.path("upstream"));
    lib.installHeadersDirectory(b.path("upstream"),"", .{
        .exclude_extensions = &.{ ".c", ".in", ".txt" },
    });

    var flags = std.ArrayList([]const u8).init(b.allocator);
    defer flags.deinit();
    try flags.appendSlice(&.{
        "-DHAVE_SYS_TYPES_H",
        "-DHAVE_STDINT_H",
        "-DHAVE_STDDEF_H",
        "-DZ_HAVE_UNISTD_H",
    });
    lib.addCSourceFiles(.{
        .files = srcs,
        .flags = flags.items
    });

    b.installArtifact(lib);
}

const srcs = &.{
    "upstream/adler32.c",
    "upstream/compress.c",
    "upstream/crc32.c",
    "upstream/deflate.c",
    "upstream/gzclose.c",
    "upstream/gzlib.c",
    "upstream/gzread.c",
    "upstream/gzwrite.c",
    "upstream/inflate.c",
    "upstream/infback.c",
    "upstream/inftrees.c",
    "upstream/inffast.c",
    "upstream/trees.c",
    "upstream/uncompr.c",
    "upstream/zutil.c",
};
