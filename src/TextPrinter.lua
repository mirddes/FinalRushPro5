import('/lua/SimSync.lua');
import('/lua/SimPlayerQuery.lua');

newInstance = function()
    return {
        print = function(str)
            PrintText(str, 20, "ffffffff", 5, 'center');
        end
    }
end