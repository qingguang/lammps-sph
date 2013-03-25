NF==1 {
    # skip next line
    if (NR!=1) {
	print "\n"
    }
    getline
    next
}

{

    print $2, $3, $4
}