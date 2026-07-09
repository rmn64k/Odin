package test_poly_deferred_self_cycle

@(deferred_in=foo)
foo :: proc(value: $T) {
	_ = value
}

main :: proc() {
	foo(1)
}
