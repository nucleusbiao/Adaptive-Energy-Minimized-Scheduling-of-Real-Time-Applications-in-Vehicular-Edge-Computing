function A = pickUpSubFunc(matrixF,i)

vector = matrixF(i,:);
SubArray = [];
A = [];
for go = 1:size(vector, 2)
    if vector(go) > 0
        SubArray = [SubArray, go];
    end
end
A = SubArray;
if ~isempty(SubArray)
    for i = 1:size(SubArray,2)
        SubArray1 = pickUpSubFunc(matrixF,SubArray(i));
        A = [A,SubArray1];
    end
end
