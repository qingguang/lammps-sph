Maxima is needed for this software.  It is an enhancement to Maxima's capabilities.


1. Pw.mac should be downloaded to a location where Maxima will find it like share/contrib.

2. Pw.mac current version is 6.4.

3. To integrate a piecewise continuous function type: 

pwint(f(x),x,a,b);
pwint(f(x),x);

4. Creating piecewise functions is aided by the pw() function.

5. Help for pw.mac is in pw.html.

6. To test pw.mac try

	batch("rtest_pw.mac", 'test);

    rtest_pw.mac should also be downloaded to a location where Maxima can find it.

7.  You will need to get Maxima.

8.  I have some examples of usage in the Maxima wiki page located at http://maxima.sourceforge.net/3rdpartycode.html 

9.  Screen Shot's made with wxMaxima, a front end for Maxima

