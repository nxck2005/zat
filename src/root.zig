const std = @import("std");

// 4KB buffer
const W_BUF: usize = 4096;
const R_BUF: usize = 4096;

pub fn zat() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // get args
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const arglen = args.len;
    if (arglen != 2) {
        std.debug.print("Usage: {s} <filename> \n", .{args[0]});
        return;
    }

    var out_buf: [W_BUF]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&out_buf);
    const stdout = &writer.interface;

    var read_buf: [R_BUF]u8 = undefined;

    const filename = args[1];
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var fr = file.reader(&read_buf);
    const reader = &fr.interface;

    while (true) {
        const rb = reader.readSliceShort(&read_buf) catch |err| {
            return err;
        };
        if (rb == 0) break;
        try stdout.writeAll(read_buf[0..rb]);
    }

    try stdout.flush();
    //std.debug.print("{} bytes written\n", .{n});
}
