function predArray = pickUpPredFunc(matrixF,i)

vector = matrixF(:,i);
predArray = [];
for go = 1:size(vector, 1)
    if vector(go) > 0
        predArray = [predArray, go];
    end
end