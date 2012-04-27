function [f1 f2 f3 f4 f5 f6] = comp_incomp(k1,k2,k3,U,V,W)

kk = k1 .^ 2 + k2 .^ 2 + k3 .^ 2;

ku = k1 .* U + k2 .* V + k3 .* W;

U_comp = k1 .* ku ./ kk;

V_comp = k2 .* ku ./ kk;

W_comp = k3 .* ku ./ kk;

U_incomp = U - U_comp;

V_incomp = V - V_comp;

W_incomp = W - W_comp;

f1 = U_incomp;

f2 = V_incomp;

f3 = W_incomp;

f4 = U_comp;

f5 = V_comp;

f6 = W_comp;

endfunction
