function retval = vautocor (X, h)
if (nargin == 1)
    retval = vautocov (X);
  elseif (nargin == 2)
    retval = vautocov (X, h);
  else
    print_usage ();
  endif

  if (min (retval (1,:)) != 0)
    retval = retval ./ (ones (rows (retval), 1) * retval(1,:));
  endif

endfunction




