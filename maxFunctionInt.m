function [ xfinal yfinal ] = maxFunctionInt( x y fun )
%maxFunctionInt finds the integer population values for which fun is
%maximized
%   The function takes the floating point population values and then checks
%   all adjacent integer population pairs, returning the values that
%   maximize the given function.

    val  = fun(floor(x), floor(y));
    if (fun(floor(x), ceil(y)) > profit)
        xfinal = floor(x);
        yfinal = ceil(x);
        val = fun(floor(x), ceil(y));


end

