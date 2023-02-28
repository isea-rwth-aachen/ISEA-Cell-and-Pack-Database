ClearPath = 'Databases\DatabaseTempData';
Folders = dir(ClearPath);
for i=3:numel(Folders)
    Folder=Folders(i);
    if Folder.isdir
        if ~contains(Folder.name, '00_') && ~contains(Folder.name, '.git')
            delete([Folder.folder '\' Folder.name '\*.mat']);
            delete([Folder.folder '\' Folder.name '\*.txt']);
            fid = fopen( [Folder.folder '\' Folder.name '\00_' Folder.name '_are_placed_here.txt'], 'wt' );
            fclose(fid);
        end
    end
end