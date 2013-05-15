## Delete all text in data file for Matlab
for filename in exten00*.dat; do echo $filename;  
awk 'fl{print $1, $2, $3, $4} /ITEM: ATOMS/{fl=1}' $filename > ${filename/.dat/.del};
done

#cp exten00*.del ~/sph-projection/.


