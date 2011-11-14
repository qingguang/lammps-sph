BEGIN {
  fl=0
}

/ITEM: TIMESTEP/{
  fl=0
  if (NR>1) {
    printf("\n")
  }
}

fl{
  for (i=3; i<NF+1; i++) {
    printf("%e ", $(i))
  }
  printf("\n")
}


/ITEM: ATOMS id/{
  fl=1
}

