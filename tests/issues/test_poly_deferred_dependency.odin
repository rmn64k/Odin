package test_poly_deferred_dependency

import "core:testing"

state: int

@(deferred_in=after)
before :: proc(value: int) {
	_ = value
}

helper :: proc(value: int) -> int {
	return value + 1
}

after :: proc(value: $T) {
	state += helper(value)
}

@(test)
test_dependency :: proc(t: ^testing.T) {
	state = 0
	{
		before(41)
	}
	testing.expect_value(t, state, 42)
}
