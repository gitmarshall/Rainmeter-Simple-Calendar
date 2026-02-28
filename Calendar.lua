local lastKey = ""

function Initialize()
    UpdateCalendar()
end

function Update()
    local key = os.date("%Y-%m-%d")
    if key ~= lastKey then
        lastKey = key
        UpdateCalendar()
    end
    return os.date("%B %Y")
end

function UpdateCalendar()
    local now = os.date("*t")
    local year, month, today = now.year, now.month, now.day
    --- local year, month, today = 2026, 7, 4 -- Manually set Year, Month, Day

    local firstDay = os.date("*t", os.time{year=year, month=month, day=1}).wday - 1
    local daysInMonth = os.date("*t", os.time{year=year, month=month+1, day=0}).day

    local cellW  = tonumber(SKIN:GetVariable("CellW"))
    local cellH  = tonumber(SKIN:GetVariable("CellH"))
    local startX = tonumber(SKIN:GetVariable("StartX"))
    local startY = tonumber(SKIN:GetVariable("StartY"))

    local tX, tY = -100, -100
    local defaultColor = SKIN:GetVariable("FontColor")

    for i = 1, 42 do
        local meterName = "Date" .. i
        local dayNumber = i - firstDay

        if dayNumber > 0 and dayNumber <= daysInMonth then
            local col = (i - 1) % 7
            local row = math.floor((i - 1) / 7)

            local x = startX + (col * cellW) + (cellW / 2)
            local y = startY + (row * cellH)

            SKIN:Bang("!SetOption", meterName, "X", x)
            SKIN:Bang("!SetOption", meterName, "Y", y)
            SKIN:Bang("!SetOption", meterName, "Text", dayNumber)
            SKIN:Bang("!ShowMeter", meterName)

            if dayNumber == today then
                tX = x + 0
                tY = y + 10.5
                SKIN:Bang("!SetOption", meterName, "FontColor", "0,0,0,255")
            else
                SKIN:Bang("!SetOption", meterName, "FontColor", defaultColor)
            end
        else
            SKIN:Bang("!HideMeter", meterName)
        end
    end

    SKIN:Bang("!SetVariable", "TodayX", tX)
    SKIN:Bang("!SetVariable", "TodayY", tY)
    SKIN:Bang("!UpdateMeter", "*")
    SKIN:Bang("!Redraw")
end