function [alpha, beta, gamma, tx, ty, tz] = unpackVars(vec, argsidx)

alpha=0; beta=0; gamma=0; tx=0; ty=0; tz=0;

if argsidx == 123456
    alpha = vec(1);
    beta = vec(2);
    gamma = vec(3);
    tx = vec(4);
    ty = vec(5);
    tz = vec(6);
    
elseif argsidx == 4
    tx = vec(1);

elseif argsidx == 456
    tx = vec(1);
    ty = vec(2);
    tz = vec(3);

elseif argsidx == 6
    tz = vec(1);
end

end