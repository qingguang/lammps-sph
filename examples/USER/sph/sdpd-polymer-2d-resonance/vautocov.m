function retval = vautocov (X, h)
[n, c] = size (X);

  if (isvector (X))
    n = length (X);
    c = 1;
    X = reshape (X, n, 1);
  endif

  X = center (X);

  if (nargin == 1)
    h = n - 1;
  endif

  retval = zeros (h + 1, 1);

  for i = 0 : h
    retval(i+1) = sum(( X(i+1:n, :) .* X(1:n-i, :) )(:)) / n;
  endfor

endfunction


