const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn read_request (io: std.Io, conn: Stream, buffer: []u8) !void {
    var recv_buffer: [1024]u8 = undefined;
    var reader = conn.reader(io, &recv_buffer);
    const length: usize = 400;
    const input = try reader.interface.peekArray(length);
    @memcpy(buffer[0..length], input[0..length]);
}
