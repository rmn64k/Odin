package test_poly_deferred

import "core:testing"

State :: struct {
	deferred_in: int,
	deferred_out: int,
	deferred_in_out: int,
	deferred_in_by_ptr: int,
	deferred_out_by_ptr: int,
	deferred_in_out_by_ptr: int,
	deferred_concrete_source: int,
	deferred_return_value: int,
}

state: State

@(deferred_in=end_in)
begin_in :: proc(value: $T) {
	_ = value
}

end_in :: proc(value: $T) {
	when T == int {
		state.deferred_in += value
	} else when T == string {
		state.deferred_in += len(value)
	}
}

@(deferred_out=end_out)
begin_out :: proc(value: $T) -> T {
	return value
}

end_out :: proc(value: $T) {
	when T == int {
		state.deferred_out += value
	} else when T == string {
		state.deferred_out += len(value)
	}
}

@(deferred_in_out=end_in_out)
begin_in_out :: proc(value: $T) -> T {
	return value
}

end_in_out :: proc(in_value, out_value: $T) {
	when T == int {
		state.deferred_in_out += in_value + out_value
	} else when T == string {
		state.deferred_in_out += len(in_value) + len(out_value)
	}
}

@(deferred_in_by_ptr=end_in_by_ptr)
begin_in_by_ptr :: proc(value: $T) {
	_ = value
}

end_in_by_ptr :: proc(value: ^$T) {
	when T == int {
		state.deferred_in_by_ptr += value^
	}
}

@(deferred_out_by_ptr=end_out_by_ptr)
begin_out_by_ptr :: proc(value: $T) -> T {
	return value
}

end_out_by_ptr :: proc(value: ^$T) {
	when T == int {
		state.deferred_out_by_ptr += value^
	}
}

@(deferred_in_out_by_ptr=end_in_out_by_ptr)
begin_in_out_by_ptr :: proc(value: $T) -> T {
	return value
}

end_in_out_by_ptr :: proc(in_value, out_value: ^$T) {
	when T == int {
		state.deferred_in_out_by_ptr += in_value^ + out_value^
	}
}

@(deferred_in=end_concrete_source)
begin_concrete_source :: proc(value: int) {
	_ = value
}

end_concrete_source :: proc(value: $T) {
	when T == int {
		state.deferred_concrete_source += value
	}
}

@(deferred_out=end_return_value)
begin_return_value :: proc(value: $T) -> T {
	return value
}

end_return_value :: proc(value: $T) -> T {
	when T == int {
		state.deferred_return_value += value
	}
	return value
}

@(test)
test_poly_deferred :: proc(t: ^testing.T) {
	state = {}

	{
		begin_in(3)
		begin_in("abc")
		begin_out(5)
		begin_out("abcd")
		begin_in_out(7)
		begin_in_out("xy")
		begin_in_by_ptr(11)
		begin_out_by_ptr(13)
		begin_in_out_by_ptr(17)
		begin_concrete_source(19)
		begin_return_value(23)
	}

	testing.expect_value(t, state.deferred_in, 6)
	testing.expect_value(t, state.deferred_out, 9)
	testing.expect_value(t, state.deferred_in_out, 18)
	testing.expect_value(t, state.deferred_in_by_ptr, 11)
	testing.expect_value(t, state.deferred_out_by_ptr, 13)
	testing.expect_value(t, state.deferred_in_out_by_ptr, 34)
	testing.expect_value(t, state.deferred_concrete_source, 19)
	testing.expect_value(t, state.deferred_return_value, 23)
}
