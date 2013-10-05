function h = subplottight(n,m,i)
% Makes borderless plots; use just like subplot
    [c,r] = ind2sub([m n], i);
    h = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
end

