const std = @import("std");

// 4KB buffer
const W_BUF: usize = 4096;
const R_BUF: usize = 4096;

pub fn zat() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // get args
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const arglen = args.len;
    if (arglen < 2) {
        // the stdin path
        var out_buf: [W_BUF]u8 = undefined;
        var writer = std.fs.File.stdout().writerStreaming(&out_buf);
        const stdout = &writer.interface;
        errdefer stdout.flush() catch {};

        var in_buf: [R_BUF]u8 = undefined;
        var in = std.fs.File.stdin().reader(&in_buf);
        const in_reader = &in.interface;
        while (true) {
            while (in_reader.takeDelimiterExclusive('\n')) |line| {
                try stdout.writeAll(line);
                try stdout.writeAll("\n");
                try stdout.flush();
            } else |err| switch (err) {
                error.EndOfStream, // stream ended not on a line break
                error.StreamTooLong, // line could not fit in buffer
                error.ReadFailed, // caller can check reader implementation for diagnostics
                => |e| return e,
            }
        }
    } else if (arglen == 2) {
        var out_buf: [W_BUF]u8 = undefined;
        var writer = std.fs.File.stdout().writerStreaming(&out_buf);
        const stdout = &writer.interface;
        errdefer stdout.flush() catch {};

        const filename = args[1];
        const file = try std.fs.cwd().openFile(filename, .{});
        defer file.close();

        var read_buf: [R_BUF]u8 = undefined;
        var fr = file.reader(&read_buf);
        const reader = &fr.interface;

        _ = try reader.streamRemaining(stdout);

        try stdout.flush();
    } else {
        std.debug.print("Usage: {s} <filename>", .{args[0]});
        return;
    }
}
