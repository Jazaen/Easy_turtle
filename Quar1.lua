local width = 9
local height = 9
local depth = 20
local chestPosition = {x = 0, y = 1, z = 0} -- Chest is directly above starting position

local function refuel()
    turtle.select(1)
    if turtle.getItemCount(1) < 5 then
        goToChest()
        for slot = 2, 16 do
            turtle.select(slot)
            if turtle.getItemCount(slot) > 0 then
                turtle.drop()
            end
        end
        turtle.select(1)
        turtle.suck(64 - turtle.getItemCount(1))
        turtle.refuel()
        goToMiningPosition()
    else
        turtle.refuel()
    end
end

local function checkFuel()
    if turtle.getFuelLevel() < (width * height * depth) then
        refuel()
    end
end

local function goToChest()
    -- Assuming chest is always directly above the starting position
    while not turtle.detectUp() do
        turtle.up()
    end
end

local function goToMiningPosition()
    while not turtle.detectDown() do
        turtle.down()
    end
end

local function depositItems()
    goToChest()
    for slot = 2, 16 do
        turtle.select(slot)
        turtle.drop()
    end
    goToMiningPosition()
end

local function digLayer()
    for y = 1, height do
        for x = 1, width do
            turtle.dig()
            if x < width then
                turtle.forward()
            end
        end
        if y < height then
            if y % 2 == 1 then
                turtle.turnRight()
                turtle.dig()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.dig()
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end
end

local function moveToNextLayer()
    if depth > 1 then
        turtle.digDown()
        turtle.down()
        depth = depth - 1
    end
end

local function mine()
    checkFuel()
    for _ = 1, depth do
        digLayer()
        if turtle.getItemCount(16) > 0 then
            depositItems()
        end
        moveToNextLayer()
    end
    depositItems() -- Deposit any remaining items after mining is done
end

mine()
