categories_per_condition = 40;

input_dir = "ObjectCategories2";
input_conditions = ["1-objects" "2-objects" "4-objects" "8-objects" "16-objects"]';
output_dir = "Gray2";
output_conditions = ["1exemplar" "2exemplars" "4exemplars" "8exemplars" "16exemplars"]';
assert(size(input_conditions, 1) == size(output_conditions, 1));

for i_condition = 1:size(input_conditions, 1)
    if i_condition == 1
        current_dir = [char(input_dir) '/' char(input_conditions(i_condition)) '/'];
        input_f = dir([current_dir '*.jpg']);
        j_sampled = randsample(size(input_f, 1), categories_per_condition);
        for j = 1:categories_per_condition
            imname = input_f(j_sampled(j)).name;
            img = imread([current_dir imname]);
            img = rgb2gray(img);
            imname = regexprep(imname, 'jpg', 'png', 'ignorecase');
            imwrite(img, [char(output_dir) '/' char(output_conditions(i_condition)) '/' imname]);
        end
    else
        category_list = dir([char(input_dir) '/' char(input_conditions(i_condition)) '/']);
        category_list = category_list(~ismember({category_list.name}, {'.', '..'}));
        assert(size(category_list, 1) == categories_per_condition);
        for i_category = 1:categories_per_condition
            current_dir =  [char(input_dir) '/' char(input_conditions(i_condition)) '/' category_list(i_category).name '/'];
            %mkdir([char(output_dir) '/' char(output_conditions(i_condition)) '/' category_list(i_category).name]);
            input_f = dir([current_dir '*.jpg']);
            for j = 1:size(input_f, 1)
                imname = input_f(j).name;
                img = imread([current_dir imname]);
                img = rgb2gray(img);
                imname = regexprep(imname, 'jpg', 'png', 'ignorecase');
                imwrite(img, [char(output_dir) '/' char(output_conditions(i_condition)) '/' category_list(i_category).name '/' imname]);
            end
        end
    end
end