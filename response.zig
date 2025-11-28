const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn send_200 (conn: Stream, io: std.Io) !void {
    const message = (
        "HTTP/1.1 200 OK\n" ++
        "Content-Length: 48\n" ++
        "Content-Type: text/html\n" ++
        "Connection: Closed\n\n" ++
        "<html><body><h1>Hello, World!</h1></body></html>"
    );
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}

pub fn send_404 (conn: Stream, io: std.Io) !void {
    const message = (
        "HTTP/1.1 404 Not Found\n" ++
        "Content-Length: 50\n" ++
        "Content-Type: text/html\n" ++
        "Connection: Closed\n\n" ++
        "<html><body><h1>File not found!</h1></body></html>"
    );
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}
