#! /bin/bash

lmp_maxima_path="[\"$(pwd)\", 
                  \"$(pwd)/nint\"]"

# append content to maxima-init.mac file

>> ~/.maxima/maxima-init.mac cat <<EOF
/* add maxima-lammps tools to the search file */
addlmppath(p):= (
  file_search_maxima: append (file_search_maxima,
    [concat(p, "/###.mac")]),
  file_search_lisp: append (file_search_lisp,
    [concat(p, "/###.lisp")]))$
map('addlmppath, ${lmp_maxima_path})$
EOF
