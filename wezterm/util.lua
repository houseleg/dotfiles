local util = {}

util.merge_tables = function(...)
    local merged = {}
    for _, table in ipairs({...}) do
        for key, value in pairs(table) do
            merged[key] = value
        end
    end
    return merged
end

return util
