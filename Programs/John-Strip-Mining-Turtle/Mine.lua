-- This Version
-- 2.13 10/11/2014
-- ChangeLogs
-- 2.04 - Adding Left or Right Support
-- 2.05 - Changing Lot Code For Some Stable And Cleaner Code
-- 2.06 - Ops Forget Fuel Chcking Code after rewrtitting
-- 2.07 - Woops My Bad i wrote back() not Back()
-- 2.08 - Fixing Imputs
-- 2.09 - Forget That i change remove line of code since i use local function now
-- 2.10 - Minor error with back that it leave one block in wall
--	  Change: Torch spacing to 8 from 10
-- 2.11 - Change: Right to left and Left to Right better understand
-- 2.12 - Add Stop Code when item are gone
-- 2.13 - i made big mistake i forget to end to new stop code
-- ToDoList
-- Add Code to place torch each time it starts
-- Add Fuel Code so can know almost how much fuel you need
-- Add second fuel slot if you go allout diggin
-- Mabye add code that make turtle make new line of tunnels

--Local
local distance = 0 -- How Far Did User Pick
local onlight = 0 -- When to Place Torch
local torch = turtle.getItemCount(1) -- How many items are in slot 1 (torch)
local chest = turtle.getItemCount(2) -- How many items are in slot 2 (chest)
local ItemFuel = turtle.getItemCount(3) -- How many items are in slot 3 (Fuel)
local waterBucket = turtle.getItemCount(5) -- How many items are in slot 5 (water bucket)
local MD = 4 -- How Many Blocks Apart From Each Mine
local MineTimes = 0 -- If Multi Mines Are ON then This will keep Count
local Fuel = 0 -- if 2 then it is unlimited no fuel needed
local NeedFuel = 0 -- If Fuel Need Then 1 if not Then 0
local Error = 0 -- 0 = No Error and 1 = Error
local Way = 0 -- 0 = Left and 1 = Right

--Checking
local function Check()
	if torch == 0 then
		print("There are no torch's in Turtle")
		Error = 1
	else
		print("There are torch's in turtle")
	end
	if chest == 0 then
		print("There are no chests")
		Error = 1
	else
		print("There are chest in turtle")
	end
	if ItemFuel == 0 then
		print("No Fuel Items")
		Error = 1
	else
		print("There is fuel")
	end
	if waterBucket == 0 then
		print("There is no water bucket in slot 4")
		Error=1
	else
		print("There is water")
	end
	repeat
		if turtle.getFuelLevel() == "unlimited" then 
			print("NO NEED FOR FUEL")
			Needfuel = 0
		elseif turtle.getFuelLevel() < 100 then
			turtle.select(3)
			turtle.refuel(1)
			Needfuel = 1
			ItemFuel = ItemFuel - 1
		elseif NeedFuel == 1 then
			Needfuel = 0
		end
	until NeedFuel == 0
end

-- Recheck if user forget something turtle will check after 15 sec
local function Recheck()
	torch = turtle.getItemCount(1)
	chest = turtle.getItemCount(2)
	ItemFuel = turtle.getItemCount(3)
	waterBucket = turtle.getItemCount(5)
	Error = 0
end

--Mining
local function ForwardM()
	repeat
		if turtle.detect() then
			turtle.dig()
		end
		if turtle.forward() then -- sometimes sand and gravel and block and mix-up distance
			TF = TF - 1
			onlight = onlight + 1
		end
		if turtle.detectUp() then
			turtle.digUp()
		end
		-- place water
		turtle.select(5)
		turtle.placeUp()
		sleep(0.3) -- let water flow
		turtle.placeUp()
		-- place block down if there is no
		turtle.select(4)
		turtle.placeDown()
		if onlight == 8 then -- Every 10 Block turtle place torch
			if torch > 0 then
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.select(1)
				turtle.place()
				turtle.turnLeft()
				turtle.turnLeft()
				torch = torch - 1
				onlight = onlight - 8
			else
				print("turtle run out of torchs")
				os.shutdown()
			end
		end
		if turtle.getItemCount(16)>0 then -- If slot 16 in turtle has item slot 6 to 16 will go to chest
			if chest > 0 then
				turtle.select(2)
				turtle.digDown()
				turtle.placeDown()
				chest = chest - 1
				for slot = 6, 16 do
					turtle.select(slot)
					turtle.dropDown()
					sleep(1.5)
				end
				turtle.select(6)
			else
				print("turtle run out of chest")
				os.shutdown()
			end
		end
		repeat
			if turtle.getFuelLevel() == "unlimited" then 
				print("NO NEED FOR FUEL")
				Needfuel = 0
			elseif turtle.getFuelLevel() < 100 then
				turtle.select(3)
				turtle.refuel(1)
				Needfuel = 1
				ItemFuel = ItemFuel - 1
			elseif ItemFuel == 0 then
				print("turtle run out of fuel")
				os.shutdown()
			elseif NeedFuel == 1 then
				Needfuel = 0
			end
		until NeedFuel == 0
	until TF == 0
end

--Warm Up For Back Program
local function WarmUpForBackProgram() -- To make turn around so it can go back
	turtle.turnLeft()
	turtle.turnLeft()
	turtle.up()
end

--Back Program
local function Back()
	repeat
		if turtle.forward() then -- sometimes sand and gravel and block and mix-up distance
			TB = TB - 1
		end
		if turtle.detect() then -- Sometimes sand and gravel can happen and this will fix it
			if TB ~= 0 then
				turtle.dig()
			end
		end
	until TB == 0
end

-- Multimines Program
local function MultiMines()
	if Way == 1 then
		turtle.turnLeft()
		turtle.down()
	else
		turtle.turnRight()
		turtle.down()
	end
	repeat
		if turtle.detect() then
			turtle.dig()
		end
		if turtle.forward() then
			MD = MD - 1
		end
		if turtle.detectUp() then
			turtle.digUp()
		end
	until MD == 0
	if Way == 1 then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
	if MineTimes == 0 then
		print("Turtle is done")
	else
		MineTimes = MineTimes - 1
	end
end

-- Restart 
local function Restart()
	TF = distance
	TB = distance
	MD = 4
	onlight = 0
end

-- Starting 
function Start()
	repeat
		ForwardM()
		WarmUpForBackProgram()
		Back()
		MultiMines()
		Restart()
	until MineTimes == 0
end

-- Start
print("Hi There Welcome to Mining Turtle Program")
print("How Far Will Turtle Go")
input = io.read()
distance = tonumber(input)
TF = distance
TB = distance
print("Left or Right")
print("0 = Left and 1 = Right")
input2 = io.read()
Way = tonumber(input2)
print("How Many Times")
input3 = io.read()
MineTimes = tonumber(input3)
Check()
if Error == 1 then 
	repeat
		sleep(10)
		Recheck()
		Check()
	until Error == 0
end
Start()
