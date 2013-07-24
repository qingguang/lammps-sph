#! /bin/bash
# add directoreis to maxima search path

minitfile=${HOME}/.maxima/maxima-init.mac
lmp_maxima_path="[\"$(pwd)\", 
                  \"$(pwd)/nint\"]"

# append content to maxima-init.mac file

touch ${minitfile}
>> ${minitfile} cat <<EOF
/* add maxima-lammps tools to the search file */
addlmppath(p):= (
  file_search_maxima: append (file_search_maxima,
    [concat(p, "/###.mac")]),
  file_search_lisp: append (file_search_lisp,
    [concat(p, "/###.lisp")]))$
map('addlmppath, ${lmp_maxima_path})$
kill(addlmppath)$
EOF
