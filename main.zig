const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig");

pub fn main () !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = alloc.allocator();
    var threaded = std.Io.Threaded.init(gpa);
    const io = threaded.io();
    defer threaded.deinit();

    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [400]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(io, connection, request_buffer[0..]);

    std.debug.print("{s}\n", .{request_buffer});
}
