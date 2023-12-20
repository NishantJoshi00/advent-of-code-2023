const std = @import("std");

const Dir = enum { left, right, top, bottom };

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

    pub fn spread_apply(self: *Table, point: Point, symbol: u8) void {
        var pt = point;
        if (self.get_char(&pt) == '.') {
            self.array[point.y][point.x] = symbol;
            if (pt.top()) |p| spread_apply(self, p, symbol);
            if (pt.left()) |p| spread_apply(self, p, symbol);
            if (pt.right()) |p| spread_apply(self, p, symbol);
            if (pt.bottom()) |p| spread_apply(self, p, symbol);
        }
    }

    pub fn count_symbol(self: *Table, symbol: u8) usize {
        var output: usize = 0;
        for (self.array) |inner| {
            for (inner) |el| {
                if (el == symbol) {
                    output += 1;
                }
            }
        }
        return output;
    }

    pub fn symbol_replace(self: *Table, src: u8, dst: u8) void {
        for (0..self.length) |i| {
            for (0..self.ilength) |j| {
                if (self.array[i][j] == src) {
                    self.array[i][j] = dst;
                }
            }
        }
    }

    pub fn apply_distance_map(self: *Table) void {
        for (0..self.length) |i| {
            for (0..self.ilength) |j| {
                if (self.distance[i][j] == -1) {
                    self.array[i][j] = '.';
                }
            }
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

    pub fn getInitialDir(self: *Table, point: *Point, alloc: std.mem.Allocator) !?struct { dir: Dir, pt: Point } {
        if (point.top()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                return .{ .dir = Dir.left, .pt = inner };
            }
        }

        if (point.left()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                return .{ .dir = Dir.top, .pt = inner };
            }
        }

        if (point.right()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                return .{ .dir = Dir.bottom, .pt = inner };
            }
        }

        if (point.bottom()) |inner| {
            var i = inner;
            if (point.contains(try self.get_next(&i, alloc))) {
                return .{ .dir = Dir.right, .pt = inner };
            }
        }
        return null;
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

    pub fn paint_dir(self: *Point, direction: Dir, symbol: u8) void {
        var data: ?Point = switch (direction) {
            Dir.left => self.left(),
            Dir.right => self.right(),
            Dir.bottom => self.bottom(),
            Dir.top => self.top(),
        };
        if (data) |pt| {
            var ipt = pt;
            self.tableRef.spread_apply(ipt, symbol);
        }
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

pub fn printArray2(comptime T: type, points: [][]u8) void {
    _ = T;
    for (points) |point| {
        for (point) |i| {
            std.debug.print("{c}", .{i});
        }
        std.debug.print("\n", .{});
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

pub fn next_direction(old: Dir, symbol: u8) Dir {
    switch (old) {
        Dir.left => {
            return switch (symbol) {
                'J' => Dir.top,
                'L' => Dir.bottom,
                'F' => Dir.top,
                '7' => Dir.bottom,
                else => old,
            };
        },
        Dir.right => {
            return switch (symbol) {
                'J' => Dir.bottom,
                'L' => Dir.top,
                'F' => Dir.bottom,
                '7' => Dir.top,
                else => old,
            };
        },
        Dir.top => {
            return switch (symbol) {
                'J' => Dir.left,
                'L' => Dir.right,
                'F' => Dir.left,
                '7' => Dir.right,
                else => old,
            };
        },
        Dir.bottom => {
            return switch (symbol) {
                'J' => Dir.right,
                'L' => Dir.left,
                'F' => Dir.right,
                '7' => Dir.left,
                else => old,
            };
        },
    }
}

pub fn wallpainter(current: Point, next: Point, current_dir: Dir, symbol: u8, alloc: std.mem.Allocator) !void {
    var current_ptr = current;
    var next_ptr = next;
    var next_dir = next_direction(current_dir, next.tableRef.get_char(&next_ptr).?);

    current_ptr.paint_dir(current_dir, symbol);
    if (next_dir != current_dir) {
        next_ptr.paint_dir(current_dir, symbol);
    }

    for (try next.tableRef.get_next(&next_ptr, alloc)) |inner| {
        var iptr = inner;
        if (inner.eq(&current_ptr) != true and inner.tableRef.get_char(&iptr).? != 'S') {
            try wallpainter(next, inner, next_dir, symbol, alloc);
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

    start.tableRef.apply_distance_map();

    var idata = try start.tableRef.getInitialDir(&start, allocator);
    var data = idata.?;

    try wallpainter(start, data.pt, data.dir, 'I', allocator);

    // start.tableRef.symbol_replace('.', 'O');

    // printArray2(u8, start.tableRef.array);

    try stdout.print("{}\n", .{start.tableRef.count_symbol('I')});
    try stdout.print("{}\n", .{start.tableRef.count_symbol('.')});
}
