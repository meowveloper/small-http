const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig");
const Response = @import("response.zig");

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
    try Request.read_request(io, connection, request_buffer[0..request_buffer.len]);

    const request = Request.parse_request(request_buffer[0..request_buffer.len]);

    if (request.method == Request.Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection, io);
        } else {
            try Response.send_404(connection, io);
        }
    }

    std.debug.print("{any}\n", .{request});
}
