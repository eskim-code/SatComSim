function cpy = copy_object(obj)

if false
    filename = 'tmp.mat';
    save(filename,'obj');
    pause(1);
    load(filename,'obj');
    pause(1);
    delete(filename);
    pause(1);
    cpy = obj;
else
    copyStream = getByteStreamFromArray(obj);
    cpy = getArrayFromByteStream(copyStream);
end

return