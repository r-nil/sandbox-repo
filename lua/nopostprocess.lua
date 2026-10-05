local empty = function() end
DrawBloom = empty
DrawMotionBlur = empty
DrawColorModify = empty
DrawSharpen = empty
DrawSobel = empty
DrawSunbeams = empty
DrawTexturize = empty
DrawMaterialOverlay = empty
hook.Add("RenderScreenspaceEffects", "E G G E D", function() end)