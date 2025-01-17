% Author: Atanu Giri
% Date: 01/15/2024

datasource = 'live_database';
conn = database(datasource,'postgres','1234');

loadFile = load("emptyIDs.mat");
emptyIDs = loadFile.emptyIDs;
idList = emptyIDs.id;

% alterQuery = "ALTER TABLE featuretable2 " + ...
% "ALTER COLUMN norm_x TYPE DOUBLE PRECISION[] " + ...
% "USING norm_x::DOUBLE PRECISION[]";
% exec(conn,alterQuery);


tableName = 'featuretable2';

for index = 1:10000
    id = idList(index);
    try
        [normT, normX, normY] = extractNormalizedCoordinate(id);

        norm_t_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normT, '%.6f')), ','));
        norm_x_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normX, '%.6f')), ','));
        norm_y_string = sprintf('ARRAY[%s]', strjoin(cellstr(num2str(normY, '%.6f')), ','));


        updateQuery = sprintf("UPDATE %s SET norm_t=%s, norm_x=%s, norm_y=%s " + ...
            "WHERE id=%d", tableName, norm_t_string, norm_x_string, norm_y_string, id);

        exec(conn, updateQuery);

    catch ME
        fprintf("Calculation error in %d: %s\n", id, ME.message);
        continue;
    end
end