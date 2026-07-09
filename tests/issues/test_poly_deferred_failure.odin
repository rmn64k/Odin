package test_poly_deferred_failure

@(deferred_none=end_none)
begin_none :: proc(value: $T) {
	_ = value
}

end_none :: proc($T: typeid) {
}

main :: proc() {
	begin_none(123)
}
