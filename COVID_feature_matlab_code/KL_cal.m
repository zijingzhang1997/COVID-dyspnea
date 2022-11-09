function KL=KL_cal(score,score2)

KL = 0;
for i = 1
    left = min(min(score2(:, i)), min(score(:, i)));
    right = max(max(score2(:, i)), max(score(:, i)));
    delta = right - left;
    left = left - 0.1 * delta;
    right = right + 0.1 * delta;
    [f1,xi] = ksdensity(score(:, i), left:(right-left)/200:right);
    [f2,yi] = ksdensity(score2(:, i), left:(right-left)/200:right);
    
    f1 = f1 + 1e-6;
    f2 = f2 + 1e-6;
    
    

    KL = KL +  sum(f2 * (right-left)/200 .* log(f2 * (right-left)/200 ./ (f1 * (right-left)/200)));
end

end 
