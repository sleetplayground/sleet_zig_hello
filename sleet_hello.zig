const std = @import("std");

// Using WASM allocator for memory management
var allocator = std.heap.wasm_allocator;

// Import NEAR runtime functions
extern fn input(register_id: u64) void;
extern fn read_register(register_id: u64, ptr: u64) void;
extern fn register_len(register_id: u64) u64;
extern fn value_return(value_len: u64, value_ptr: u64) void;
extern fn log_utf8(len: u64, ptr: u64) void;
extern fn storage_write(key_len: u64, key_ptr: u64, value_len: u64, value_ptr: u64, register_id: u64) u64;
extern fn storage_read(key_len: u64, key_ptr: u64, register_id: u64) u64;

const SCRATCH_REGISTER = 0xffffffff;
const GREETING_KEY = "greeting";
const DEFAULT_GREETING = "Hello from Sleet!";

// Helper functions
fn log(str: []const u8) void {
    log_utf8(str.len, @intFromPtr(str.ptr));
}

fn valueReturn(value: []const u8) void {
    value_return(value.len, @intFromPtr(value.ptr));
}

fn readRegisterAlloc(register_id: u64) []const u8 {
    const len: usize = @truncate(register_len(register_id));
    const bytes = allocator.alloc(u8, len + 1) catch {
        log("Failed to allocate memory");
        return "";
    };
    read_register(register_id, @intFromPtr(bytes.ptr));
    return bytes[0..len];
}

fn readInputAlloc() []const u8 {
    input(SCRATCH_REGISTER);
    return readRegisterAlloc(SCRATCH_REGISTER);
}

fn readStorageAlloc(key: []const u8) ?[]const u8 {
    const res = storage_read(key.len, @intFromPtr(key.ptr), SCRATCH_REGISTER);
    return switch (res) {
        0 => null,
        1 => readRegisterAlloc(SCRATCH_REGISTER),
        else => null,
    };
}

fn storageWrite(key: []const u8, value: []const u8) bool {
    const res = storage_write(key.len, @intFromPtr(key.ptr), value.len, @intFromPtr(value.ptr), SCRATCH_REGISTER);
    return switch (res) {
        0 => false,
        1 => true,
        else => false,
    };
}

// Contract methods
export fn get_greeting() void {
    const greeting = readStorageAlloc(GREETING_KEY) orelse DEFAULT_GREETING;
    log(greeting);
    valueReturn(greeting);
}

export fn set_greeting() void {
    const new_greeting = readInputAlloc();
    if (new_greeting.len == 0) {
        log("Empty greeting not allowed");
        return;
    }
    _ = storageWrite(GREETING_KEY, new_greeting);
    log("Greeting updated successfully");
    valueReturn(new_greeting);
}