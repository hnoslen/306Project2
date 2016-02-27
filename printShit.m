function printShit(vect,places)
for n = 1:numel(vect)
    display(sprintf(['%.' num2str(places) 'f'], vect(n)))
end
end

