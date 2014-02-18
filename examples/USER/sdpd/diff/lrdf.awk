/^#/ {
    next
}

NF==2 {
    if (p) {
	print p
    }
    p = 0
    next
}

$3>p {
    p = $3
}


