clc
clear all
main_path = 'E:\BB Project\generative model images\2- Cell cycle generative model';   %  Path to the main results folder
main_path2 = "E:\BB Project\generative model images\2- Cell cycle generative model"; 
currLabel = 1;
labels = [];
data = [];
paths = ["N=1"; "N=2"; "N=3";];
names = ["measured"; "synthetic"];
skipped = 0;
for i=1:length(paths)
    full_path = fullfile(main_path, paths(i));
    D = dir(full_path); % A is a struct ... first elements are '.' and '..' used for navigation.    
%     currLabel = currLabel + 1;
    for k = 3:length(D) % avoid using the first ones
        currD = D(k).name; % Get the current subdirectory name
        
        tempPath = fullfile(full_path, currD);
        fList = dir(tempPath); % Get the file list in the subdirectory
        for j = 3:length(fList)
            currD = fList(j).name;
            if strcmp(currD, 'Summary.txt')
%                 T = str2double(table2array(readtable(fullfile(tempPath, currD), 'ReadVariableNames', false)));
                T = readData(fullfile(tempPath, currD));
                if T ~= 0
                    data(end+1,:) = T;
                    labels(end+1) = currLabel;
                else
                    skipped = skipped + 1;
                end
            end
        end

    end
end
% writematrix(data, 'data_all.csv');

full_path = 'E:\BB Project\generative modeling\models';
D = dir(full_path); % A is a struct ... first elements are '.' and '..' used for navigation.    
currLabel = currLabel + 1;
for k = 3:length(D) % avoid using the first ones
    currD = D(k).name; % Get the current subdirectory name
    if contains(currD, '.txt')
        T = readData(fullfile(full_path, currD));
        if T ~= 0
            data(end+1,:) = T;
            labels(end+1) = currLabel;
        else
            skipped = skipped + 1;
        end
    end

end
% full_path = 'E:\BB Project\generative modeling\models3';
% D = dir(full_path); % A is a struct ... first elements are '.' and '..' used for navigation.    
% currLabel = currLabel + 1;
% for k = 3:length(D) % avoid using the first ones
%     currD = D(k).name; % Get the current subdirectory name
%     if contains(currD, '.txt')
%         T = readData(fullfile(full_path, currD));
%         if T ~= 0
%             data(end+1,:) = T;
%             labels(end+1) = currLabel;
%         else
%             skipped = skipped + 1;
%         end
%     end
% 
% end



for i = 1:22
    maxV = max(data(:, i));
    minV = min(data(:, i));
    data(:, i) = data(:, i) - mean(data(1:336, i));
    data(:, i) = data(:, i)/(maxV-minV);
end
data2 = data(:, [1,3,5,7,13:end]);
[coeff,score,latent,tsquared,explained,mu] = pca(data(1:336, :));
score2 = data(337:end, :)*coeff;
% score3 = data(383:end, :)*coeff;

latent2 = latent / sum(latent);
colors = {'green', 'magenta', 'cyan', 'red'};
markers = {'o'};
figure(10)

pos1 = [0.1 0.1 0.6 0.6];
subplot('Position',pos1)




% color = colors{mod(i, 4)+1};
% marker = markers{fix(i/4) + 1};
scatter(score(:, 1), score(:, 2), 30,  colors{1}, 'o');
hold on
scatter(score2(:, 1), score2(:, 2), 30,  colors{2}, 'o');
hold on

% plot(score2(:, 1), score2(:, 2));

% scatter(score3(:, 1), score3(:, 2), 30,  colors{4}, 'o');
% hold on
% 
% plot(score3(:, 1), score3(:, 2));
% scatter(score(labels==i+1, 1), score(labels==i+1, 2), 20,  'blue', 's');
% scatter(score(labels==i+2, 1), score(labels==i+2, 2), 20,  'red', 's');
% b = score(labels==i-1, 2)';
% title('PCA Embedding Plot')

xlabel('PC1(59.91%)')
ylabel('PC2(14.98%)')
box on
hold off



left = min(min(score(:, 1)), min(score2(:, 1)));
right = max(max(score(:, 1)), max(score2(:, 1)));
delta = right - left;
left = left - 0.1 * delta;
right = right + 0.1 * delta;
[f1,x1] = ksdensity(score(:, 1), left:(right-left)/200:right);
[f2,x1] = ksdensity(score2(:, 1), left:(right-left)/200:right);


xlim([left right])

left = min(min(score(:, 2)), min(score2(:, 2)));
right = max(max(score(:, 2)), max(score2(:, 2)));
delta = right - left;
left = left - 0.1 * delta;
right = right + 0.1 * delta;
[f3,x2] = ksdensity(score(:, 2), left:(right-left)/200:right);
[f4,x2] = ksdensity(score2(:, 2), left:(right-left)/200:right);


ylim([left right])
legend(names);

pos2 = [0.1 0.71 0.6 0.15];
subplot('Position',pos2);
plot(x1, f1, x1, f2);
% title('Second Subplot')
axis off

pos3 = [0.71 0.1 0.15 0.6];
subplot('Position',pos3);
plot(f3, x2, f4, x2);
% title('Second Subplot')
axis off


%%% weighted KL
KL = 0;
for i = 1:22
    left = min(min(score(:, i)), min(score2(:, i)));
    right = max(max(score(:, i)), max(score2(:, i)));
    delta = right - left;
    left = left - 0.1 * delta;
    right = right + 0.1 * delta;
    [f1,xi] = ksdensity(score(:, i), left:(right-left)/200:right);
    [f2,~] = ksdensity(score2(:, i), left:(right-left)/200:right);

    KL = KL + 0.01 * explained(i) * sum(f2 * (right-left)/200 .* log(f2 * (right-left)/200 ./ (f1 * (right-left)/200)));
end


%%% feature importance
featureImportance = zeros(18, 1);
legend(names);
all_ = sum(latent);
for i = 1:22
    sum_ = 0;
    for j = 1:22
        sum_ = sum_ + coeff(i, j)^2 * explained(j);
    end
    featureImportance(i, 1) = sum_;
end
featureImportance

warning('off','all')


function T = readData(txtPath)
q = 1;
T = zeros(1,19);

Str = fileread(txtPath);
Keys = ["Anterior Area (um^2):"; "# Anterior BBs:"; "Medial Area (um^2):"; "# Medial BBs:"; "Posterior Area (um^2):";...
    "# Posterior BBs:"; "# assigned BBs:"; "# BB rows:"; "Avergae number of BBs per row:"; "Cell height(um):"; "Cell widths(um):";...
    "Cell volume(um^3):"; "VolumeDeficit:"; "Average neighbor BB pairwise distance(um) (anterior, medial, posterior):"; "Average BB row pairwise distance(um) (anterior, medial, posterior):";...
    "Mean and standard deviation of ciliary row lengths:"];

    for p=1:length(Keys)
        Key = convertStringsToChars(Keys(p));
        Index = strfind(Str, Key);
        if p==11 || p==16
            Value = sscanf(Str(Index(1) + length(Key):end), '%g, %g', 2);
            for j=1:2
                T(q)=Value(j);
                q = q+1;
            end
        elseif p==14 || p==15
            Value = sscanf(Str(Index(1) + length(Key):end), '%g, %g, %g', 3);
            for j=1:3
                T(q)=Value(j);
                q = q+1;
            end
        else
            try
                Value = sscanf(Str(Index(1) + length(Key):end), '%f', 1);
            catch
                T = 0;
                return
            end
            T(q)=Value;
            q = q+1;
        end
    end
end




