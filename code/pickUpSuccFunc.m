function succArray = pickUpSuccFunc(matrixF,i)

vector = matrixF(i,:);
succArray = [];
for go = 1:size(vector, 2)
    if vector(go) > 0
        succArray = [succArray, go];
    end
end