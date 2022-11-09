
function h=GaussianPlot(score,score2,score3,colors,names,FeatNames,XYlim)

h=figure();
%[left bottom width height]
a=0.15;
pos1 = [a a 0.6 0.6];
subplot('Position',pos1)




% color = colors{mod(i, 4)+1};
% marker = markers{fix(i/4) + 1};
scatter(score(:, 1), score(:, 2), 20,  colors{1}, 'o');
hold on
scatter(score2(:, 1), score2(:, 2), 20,  colors{2}, 'o');
hold on
scatter(score3(:, 1), score3(:, 2), 30,  colors{3}, 'o');
hold on
sz=14;
xlabel(FeatNames{1},'FontSize',sz)
ylabel(FeatNames{2},'FontSize',sz)


% left = min([min(score(:, 1)), min(score2(:, 1)), min(score3(:, 1))]);
% right = max([max(score(:, 1)), max(score2(:, 1)),max(score3(:, 1))]);
left = min([min(score(:, 1)), min(score(:, 1)), min(score3(:, 1))]);
right = max([max(score(:, 1)), max(score(:, 1)),max(score3(:, 1))]);
delta = right - left;
left = left - 0.1 * delta;
right = right + 0.1 * delta;
[f1{1},x1] = ksdensity(score(:, 1), left:(right-left)/200:right);
[f1{2},x1] = ksdensity(score2(:, 1), left:(right-left)/200:right);
[f1{3},x1] = ksdensity(score3(:, 1), left:(right-left)/200:right);



xlim([left right])

left = min(min(score(:, 2)), min(score3(:, 2)));
right = max(max(score(:, 2)), max(score3(:, 2)));
delta = right - left;
left = left - 0.1 * delta;
right = right + 0.1 * delta;
[f2{1},x2] = ksdensity(score(:, 2), left:(right-left)/200:right);
[f2{2},x2] = ksdensity(score2(:, 2), left:(right-left)/200:right);
[f2{3},x2] = ksdensity(score3(:, 2), left:(right-left)/200:right);
pos2 = [a 0.78 0.6 a];
pos3 = [0.78 a a 0.6];
ylim([left right])
legend(names,'Position',[0.72 0.78 0.22 0.1],'FontSize',sz-2);
legend box off 

lw=1;
subplot('Position',pos2);
plot(x1, f1{1},colors{1}, x1, f1{2},colors{2},x1, f1{3},colors{3},'LineWidth',lw);

axis off


subplot('Position',pos3);
plot( f2{1},x2,colors{1}, f2{2},x2,colors{2}, f2{3},x2,colors{3},'LineWidth',lw);

axis off



end




