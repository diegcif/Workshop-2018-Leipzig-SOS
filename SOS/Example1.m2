restart
needsPackage ("SOS" , Configuration => { "CSDPexec" => "CSDP/csdp"})

-- R = QQ[x1,x2]
-- h1 = x2^4*x1+3*x1^3-x2^^4 -3*x1^2
-- h2 = x1^2*x2 - 2*x1^2
-- h3 = 2*x2^4*x1 - x1^3 -2*x2^4 +x1^2
-- 
-- t = 4
-- 
-- -- Even simpler



formPoly = (coeff, mon) -> sum apply (coeff, mon, (i,j)->i*j)

genericCombination = (h, D) -> (
    -- h is a list of polynomials
    -- D is a maximumd degree
    R := ring h#0;
    -- compute monomials
    p := symbol p;
    mon := for i to #h-1 list (
        di := D - first degree h#i;
        flatten entries basis (di, R)
        );
    -- ring of parameters
    pvars := for i to #h-1 list
        toList( p_(i,0)..p_(i,#(mon#i)-1) );
    S := newRing (R, Variables=> gens R|flatten pvars);
    pvars = for i to #h-1 list apply (pvars#i, m->S_m);
    -- polynomial multipliers
    g := for i to #h-1 list
        formPoly ( pvars#i , apply (mon#i, m -> sub (m, S)) );
    F := sum apply (h,g, (i,j)->sub(i,S)*j);
    return (F,flatten pvars);
    )

R = QQ[x,y,z]
h1 = x^2 + y^2
h2 = y^2 + z^2
h = {h1,h2}

(f,p) = genericCombination(h, 2)

(Q,mon,X,tval) = solveSOS (f, p, Solver=>"CSDP")