function [ xfinal, yfinal ] = maxFunctionInt( x, y, fun )
%maxFunctionInt finds the integer population values for which fun is
%maximized
%   The function takes the floating point population values and then checks
%   all adjacent integer population pairs, returning the values that
%   maximize the given function.

    val  = fun(floor(x), floor(y));
    x = floor(x);
    y = floor(y);
    if (fun(floor(x), ceil(y)) > val)
        x = floor(x);
        y = ceil(x);
        val = fun(floor(x), ceil(y));
    elseif (fun(ceil(x), floor(y)) > val)
        x = ceil(x);
        y = floor(x);
        val = fun(ceil(x), floor(y));
    elseif (fun(ceil(x), ceil(y)) > val)
        x = ceil(x);
        y = ceil(x);
        val = fun(ceil(x), ceil(y));    
    end
    
    xfinal = x;
    yfinal = y;
    
    %display(xfinal)
    %display(yfinal)
end

