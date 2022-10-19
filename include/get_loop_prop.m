function [Span, Coercive] = get_loop_prop(feloop)
    %FIXME: add linear interp to find coercive field
    
    E = feloop.E;
    P = feloop.P;
    
    
    Span.p = abs(P.p(end) - P.p(1));
    Span.n = abs(P.n(end) - P.n(1));
    
    if feloop.align
        [~, ind_p] = min(abs(P.p));
        [~, ind_n] = min(abs(P.n));
    else
        [~, ind_p] = min(abs(P.p - Span.p/2));
        [~, ind_n] = min(abs(P.n - Span.n/2));
    end
    
    Coercive.p = abs(E.p(ind_p));
    Coercive.n = abs(E.n(ind_n));

end