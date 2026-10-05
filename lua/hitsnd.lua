local config = {
    hitsndpath = "ambient/levels/canals/windchime2.wav",
    hitsndpitch = 155,
    hitsndkillpath = "ambient/alarms/warningbell1.wav",
    hitsndkillpitch = 145,
    hitsndvol = 2,
}

local LocalPlayer = LocalPlayer

gameevent.Listen("player_hurt")
hook.Add("player_hurt", "absolutely hitsound cinema", function(data)
    local hp = data.health
    local victim = Player(data.userid)
    if not IsValid(victim) then return end
    local attacker = Player(data.attacker)
    if not IsValid(attacker) then
        local e = Entity(data.attacker)
        if IsValid(e) then
            attacker = e
        else
            return
        end
    end

    hp = math.max(hp,0)
    if attacker ~= LocalPlayer() then return end

    timer.Create("hitsnd_" .. data.userid,0.05,1,function()
        hp = victim:Health()
        if victim ~= lp then
            sound.PlayFile("sound/" .. (hp <= 0 and config.hitsndkillpath or config.hitsndpath), "noplay", function(chan)
                chan:Play()
                chan:SetPlaybackRate((hp <= 0 and config.hitsndkillpitch or config.hitsndpitch) / 100)
                chan:SetVolume(miscconfig.hitsndvol)
            end)
        end
    end)
end)
