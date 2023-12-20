const std = @import("std");

const Table = struct {
    array: [][]u8,
    length: usize,
    ilength: usize,
    distance: [][]isize,

    pub fn get_char(self: *Table, point: *Point) ?u8 {
        if ((point.x < self.ilength and point.x >= 0) and (point.y < self.length and point.y >= 0)) {
            return self.array[point.y][point.x];
        } else {
            return null;
        }
    }

    pub fn update_distance(self: *Table, pt: *Point, value: isize) bool {
        if (self.distance[pt.y][pt.x] == -1 or self.distance[pt.y][pt.x] > value) {
            self.distance[pt.y][pt.x] = value;
            return true;
        }
        return false;
    }

    pub fn find_start(self: *Table) ?Point {
        for (self.array, 0..) |inner, i| {
            for (inner, 0..) |el, j| {
                if (el == 'S') {
                    return Point{ .x = j, .y = i, .tableRef = self };
                }
            }
        }
        return null;
    }

    pub fn validate(self: *Table, point: *Point) bool {
        return ((point.x < self.ilength and point.x >= 0) and (point.y < self.length and point.y >= 0));
    }

    pub fn startLookup(self: *Table, point: *Point, alloc: std.mem.Allocator) ![]Point {
        var output = try alloc.alloc(Point, 0);
        if (point.top()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                output = try makeArray(Point, alloc, output, point.top());
            }
        }

        if (point.left()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                output = try makeArray(Point, alloc, output, point.left());
            }
        }

        if (point.right()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                output = try makeArray(Point, alloc, output, point.right());
            }
        }

        if (point.bottom()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                output = try makeArray(Point, alloc, output, point.bottom());
            }
        }

        return output;
    }

    pub fn get_next(self: *Table, point: *Point, alloc: std.mem.Allocator) ![]Point {
        var empty_start = try alloc.alloc(Point, 0);
        if (self.get_char(point)) |inner| {
            // std.debug.print("{c}\n", .{inner});
            return switch (inner) {
                '|' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.bottom()), point.top()),
                '-' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.left()), point.right()),
                'L' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.top()), point.right()),
                'J' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.top()), point.left()),
                '7' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.bottom()), point.left()),
                'F' => try makeArray(Point, alloc, try makeArray(Point, alloc, empty_start, point.bottom()), point.right()),
                // 'S' => try self.startLookup(point, alloc),
                else => empty_start,
            };
        } else {
            return empty_start;
        }
    }
};

const Point = struct {
    tableRef: *Table,
    x: usize,
    y: usize,

    pub fn new(x: usize, y: usize, table: *Table) Point {
        return Point{ .x = x, .y = y, .tableRef = table };
    }

    pub fn eq(self: Point, other: *Point) bool {
        return (self.x == other.x and self.y == other.y);
    }
    pub fn contains(self: *Point, array: []Point) bool {
        for (array) |el| {
            if (el.eq(self)) {
                return true;
            }
        }
        return false;
    }

    pub fn top(self: *Point) ?Point {
        if (self.y == 0) return null;
        var newPoint = Point.new(self.x, self.y - 1, self.tableRef);
        return if (self.tableRef.validate(&newPoint)) newPoint else null;
    }

    pub fn bottom(self: *Point) ?Point {
        if (self.y == self.tableRef.length - 1) return null;
        var newPoint = Point.new(self.x, self.y + 1, self.tableRef);
        return if (self.tableRef.validate(&newPoint)) newPoint else null;
    }

    pub fn left(self: *Point) ?Point {
        if (self.x == 0) return null;
        var newPoint = Point.new(self.x - 1, self.y, self.tableRef);
        return if (self.tableRef.validate(&newPoint)) newPoint else null;
    }

    pub fn right(self: *Point) ?Point {
        if (self.x == self.tableRef.ilength - 1) return null;
        var newPoint = Point.new(self.x + 1, self.y, self.tableRef);
        return if (self.tableRef.validate(&newPoint)) newPoint else null;
    }
    // }
};

fn makeArray(comptime T: type, alloc: std.mem.Allocator, array: []T, value: ?T) ![]T {
    if (value) |inner| {
        // Get the length of the existing array
        const length = array.len;

        // Allocate memory for a new array with one additional element
        const newLength = length + 1;
        var output = try alloc.alloc(T, newLength);
        std.mem.copy(T, output, array);

        // Copy the existing elements to the new array
        output[newLength - 1] = inner;

        // Update the original array
        return output;
    }

    return array;
}

pub fn printArray(points: []Point) void {
    std.debug.print("[", .{});
    for (points) |point| {
        std.debug.print("({any},{any}),", .{ point.x, point.y });
    }
    std.debug.print("]\n", .{});
}

pub fn printArray2(points: [][]isize) void {
    for (points) |point| {
        std.debug.print("{any}\n", .{point});
    }
}

pub fn solve_my_problem_plij(point: Point, big_array: []Point, cursor: usize, alloc: std.mem.Allocator) !void {
    var pt = point;
    var cus = cursor;
    var possibilities: []Point = undefined;
    if (point.tableRef.get_char(&pt) == 'S') {
        possibilities = try point.tableRef.startLookup(&pt, alloc);
    } else {
        possibilities = try point.tableRef.get_next(&pt, alloc);
    }
    // printArray(possibilities);
    for (possibilities) |pos| {
        var ipos = pos;
        if (ipos.tableRef.update_distance(&ipos, @intCast(cus))) {
            // std.debug.print("{c} -> {c}\n", .{ point.tableRef.get_char(&pt).?, point.tableRef.get_char(&ipos).? });
            big_array[cus] = pos;
            cus += 1;
            try solve_my_problem_plij(pos, big_array, cursor + 1, alloc);
            cus -= 1;
        }
    }
}

pub fn max(diss: [][]isize) isize {
    var inner_max: isize = -1;
    for (diss) |ell| {
        for (ell) |el| {
            if (el > inner_max) {
                inner_max = el;
            }
        }
    }
    return inner_max;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const in = std.io.getStdIn();
    var buf = std.io.bufferedReader(in.reader());
    var r = buf.reader();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var msg_buf: [10000]u8 = undefined;

    var output = try allocator.alloc([]u8, 4096);
    var counter: usize = 0;

    while (try r.readUntilDelimiterOrEof(&msg_buf, '\n')) |line| {
        var inner_array = try allocator.alloc(u8, line.len);
        std.mem.copy(u8, inner_array, line);

        output[counter] = inner_array;
        counter += 1;
    }
    output = output[0..counter];

    var distance = try allocator.alloc([]isize, output.len);
    for (distance, 0..) |_, idx| {
        distance[idx] = try allocator.alloc(isize, output[0].len);
        for (distance[idx], 0..) |_, jdx| {
            distance[idx][jdx] = -1;
        }
    }
    var table = Table{ .array = output, .length = output.len, .ilength = output[0].len, .distance = distance };
    var start = table.find_start().?;
    var point_array = try allocator.alloc(Point, start.tableRef.length * start.tableRef.ilength);
    var size: usize = 0;
    point_array[size] = start;
    size += 1;

    _ = start.tableRef.update_distance(&start, 0);

    try solve_my_problem_plij(start, point_array, size, allocator);

    try stdout.print("{any}!\n", .{max(start.tableRef.distance)});
}
