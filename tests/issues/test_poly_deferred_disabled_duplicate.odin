package test_poly_deferred_disabled_duplicate

@(deferred_in=after)
before :: proc(value: $T) {
	_ = value
}

@(disabled=true)
after :: proc(value: int) {
	_ = value
}

main :: proc() {
	before(1)
	before(2)
}
