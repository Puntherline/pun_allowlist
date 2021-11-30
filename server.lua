-- CREDITS
-- Enfer       | Some bits of code but mostly the logic and idea on how I wanted this script to work in the end.
-- Frazzle     | Basically 100% of the code that makes the passwords work (https://gist.github.com/FrazzIe/f59813c137496cd94657e6de909775aa)



-- Config
Config = {}
Config.UseAllowlist = false                        -- Use allowlist? Only people that are allowlisted are allowed to join.
Config.UsePassword  = false                        -- Use password? If allowlist and password are true, you have to be allowlisted and know the password.
Config.Password     = 'password'                   -- Password
Config.Attempts     = 3                            -- How many attempts a user has to enter the correct password
Config.CleverMode   = true                         -- Use clever mode? If this is true, you will have to either be allowlisted *or* know the password. Recommended.
Config.DiscordLink  = 'https://discord.gg/4QMdYMX' -- Your Discord server invite link.
Config.DeferralWait = 0.5                          -- Wait X amount of seconds before executing the next deferral. Increase for stability.
Config.Allowlist    = {                            -- You normally only need one identifier per person.
    'steam:11000010a2324b4',                               -- Puntherline: Steam
    'license:145ebc08c3ab10a72172c4e98483a4329a3f876e',    -- Puntherline: FiveM
    'xbl:2535410249652434',                                -- Puntherline: Xbox Live
    'live:1055521767134379',                               -- Puntherline: Live again?
    'discord:250304825902759936',                          -- Puntherline: Discord
    'ip:87.151.236.79'                                     -- Puntherline: IP
}



-- Globals
local lastDeferral = {}
local attempts = {}
local passwordCard = {["type"]="AdaptiveCard",["minHeight"]="100px",["body"]={{["type"]="Container",["items"]={{["type"]="TextBlock",["horizontalAlignment"]="Left",["text"]="Password",},{["type"]="Input.Text",["id"]="password",["placeholder"]="Enter Password"},{["type"]="Container",["isVisible"]=false,["items"]={{["type"]="TextBlock",["weight"]="Bolder",["color"]="Attention",["text"]="Error: Invalid password entered!"}}}}}},["actions"]={{["type"]="Action.Submit",["title"]="Enter"}},["$schema"]="http://adaptivecards.io/schemas/adaptive-card.json",["version"]="1.2"}



-- Main logic. Too lazy to make it more efficient and I'm certainly not going to change code that already works.
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)

    -- Locals
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local identifiersNum = #GetPlayerIdentifiers(player)
    local allowed = false
    local newInfo = ""
    local oldInfo = ""

    -- Stopping user from joining
    deferrals.defer()
    lastDeferral["id" .. player] = os.clock()

    while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
        Citizen.Wait(10)
    end
    deferrals.update('Please wait...')
    lastDeferral["id" .. player] = os.clock()

    -- Allowlist only
    if Config.UseAllowlist and not Config.UsePassword and not Config.CleverMode then
        for k1, v in pairs(identifiers) do
            for k2, i in ipairs(Config.Allowlist) do
                if string.match(v, i) then
                    allowed = true
                    break
                end
            end
        end

        if allowed then
            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                Citizen.Wait(10)
            end
            deferrals.done()
        else
            for k1, v in pairs(identifiers) do
                oldInfo = newInfo
                newInfo = string.format("%s\n%s", oldInfo, v)
            end
            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                Citizen.Wait(10)
            end
            deferrals.done('You\'re not allowlisted. To get allowlisted join our Discord server at '..Config.DiscordLink..' and provide us this info:\n'..newInfo)
        end
    end

    -- Password only
    if not Config.UseAllowlist and Config.UsePassword and not Config.CleverMode then
        local function passwordCardCallback(data, rawData)
            local match = false

            if data then
                if data.password then
                    if data.password == Config.Password then
                        match = true
                    end
                end
            end

            if not match then
                if not attempts[player] then
                    attempts[player] = 1
                else
                    attempts[player] = attempts[player] + 1
                end

                if attempts[player] < Config.Attempts then
                    showPasswordCard(player, deferrals, passwordCardCallback, true, attempts[player])
                else
                    while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                        Citizen.Wait(10)
                    end
                    deferrals.done('You failed '..Config.Attempts..' times, please try again.')
                end
            else
                while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                    Citizen.Wait(10)
                end
                deferrals.done()
            end
        end
        showPasswordCard(player, deferrals, passwordCardCallback)
    end

    -- Allowlist and Password or CleverMode
    if (Config.UseAllowlist and Config.UsePassword) or Config.CleverMode then
        for k1, v in pairs(identifiers) do
            for k2, i in ipairs(Config.Allowlist) do
                if string.match(v, i) then
                    allowed = true
                    break
                end
            end
        end

        if Config.CleverMode and allowed then
            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                Citizen.Wait(10)
            end
            deferrals.done()
        elseif (not Config.CleverMode and allowed) or (Config.CleverMode and not allowed) then
            local function passwordCardCallback(data, rawData)
                local match = false
    
                if data then
                    if data.password then
                        if data.password == Config.Password then
                            match = true
                        end
                    end
                end
    
                if not match then
                    if not attempts[player] then
                        attempts[player] = 1
                    else
                        attempts[player] = attempts[player] + 1
                    end
    
                    if attempts[player] < Config.Attempts then
                        showPasswordCard(player, deferrals, passwordCardCallback, true, attempts[player])
                    else
                        if not Config.CleverMode then
                            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                                Citizen.Wait(10)
                            end
                            deferrals.done('You failed '..Config.Attempts..' times, please try again.')
                        elseif Config.CleverMode then
                            for k1, v in pairs(identifiers) do
                                oldInfo = newInfo
                                newInfo = string.format("%s\n%s", oldInfo, v)
                            end
                            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                                Citizen.Wait(10)
                            end
                            deferrals.done('You\'re not allowlisted and got the password wrong '..Config.Attempts..' times. To bypass the password you need to get allowlisted over at our Discord server '..Config.DiscordLink..' and provide us this info:\n'..newInfo)
                        end
                    end
                else
                    while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                        Citizen.Wait(10)
                    end
                    deferrals.done()
                end
            end
            showPasswordCard(player, deferrals, passwordCardCallback)
        elseif not allowed then -- not allowed, refuse connection
            for k1, v in pairs(identifiers) do
                oldInfo = newInfo
                newInfo = string.format("%s\n%s", oldInfo, v)
            end
            while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
                Citizen.Wait(10)
            end
            deferrals.done('You\'re not allowlisted. To get allowlisted join our Discord server at '..Config.DiscordLink..' and provide us this info:\n'..newInfo)
        end
    end

    if not Config.UseAllowlist and not Config.UsePassword and not Config.CleverMode then
        while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
            Citizen.Wait(10)
        end
        deferrals.done()
    end
end)



-- Function to show the password card
function showPasswordCard(player, deferrals, callback, showError, numAttempts)
    local card = passwordCard
    card.body[1].items[3].isVisible = showError and true or false
    if showError and numAttempts then
        if numAttempts <= 1 then
            card.body[1].items[3].items[1].text = 'Error: Invalid password entered! ('..(Config.Attempts - numAttempts)..' attempt remaining!)'
        else
            card.body[1].items[3].items[1].text = 'Error: Invalid password entered! ('..(Config.Attempts - numAttempts)..' attempts remaining!)'
        end
    end
    while lastDeferral["id" .. player] + Config.DeferralWait > os.clock() do
        Citizen.Wait(10)
    end
    deferrals.presentCard(card, callback)
    lastDeferral["id" .. player] = os.clock()
end
