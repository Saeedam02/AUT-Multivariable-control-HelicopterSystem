function saveCurrentFigure(folder, baseName)
%SAVECURRENTFIGURE Save the current figure reproducibly as PNG and FIG.

    if ~isfolder(folder)
        mkdir(folder);
    end
    fig = gcf;
    exportgraphics(fig, fullfile(folder, baseName + ".png"), "Resolution", 200);
    savefig(fig, fullfile(folder, baseName + ".fig"));
end
