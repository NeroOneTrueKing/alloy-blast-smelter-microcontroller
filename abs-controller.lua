-- this microcontroller program is to automate removing programmed circuits [and control tokens] from an input bus / transvector interface
-- it checks if that input bus has <=2 items in it, expecting:
-- * a programmed circuit
-- * an 'alloy blast smelter token' or otherwise unique identifier
-- when that condition is true, it moves the items (progammed circuit, then token if applicable) from the input bus / transvector interface to the me interface

local tp = component.proxy(component.list("transposer")())

local expectToken = true;
local tokenName = "alloy blast smelter token";

function GetSides()
	local inputBus;
	local meInterface;

	-- notes on inventory names:
	-- blockinterface   == AE2 ME Interface
	-- fluid_interface  == AE2 Dual Interface
	-- gt.blockmachines == any standard input bus
	-- tile.interface   == thaumcraft transvector interface

	for side=0,5 do
		local name = tp.getInventoryName(side);
		if name ~= nil then
			name = string.lower(name);
			if string.find(name, "blockinterface")
			or string.find(name, "fluid_interface") then
				meInterface = side;
			elseif string.find(name, "gt.blockmachines")
			or     string.find(name, "tile.interface") then
				inputBus = side;
			end
		end
	end

	return inputBus, meInterface;
end

function TransferItemByName(sourceSide, sinkSide, itemName)
	local items = tp.getAllStacks(sourceSide);
	local i = 1;
	for item in items do
		if next(item) then
			if string.find(string.lower(item.label), itemName) then
				--transferItem(sourceSide:number, sinkSide:number, count:number, sourceSlot:number, sinkSlot:number)
				tp.transferItem(sourceSide, sinkSide, 1, i);
			end
		end
		i = i+1;
	end
end

function ItemCount(items)
	local n = 0;
	for item in items do
		if item.label then
			n = n+1;
		end
	end
	return n;
end

-----------------------------------------------------------------------------------
-- PROGRAM STARTS HERE

-- get sides
local inputBus, meInterface = GetSides();

-- MAIN LOOP
while true do
	local items = tp.getAllStacks(inputBus);
	if ItemCount(items) <= (expectToken and 2 or 1) then
		TransferItemByName(inputBus, meInterface, "programmed circuit");
		if (expectToken) then
			TransferItemByName(inputBus, meInterface, tokenName);
		end
	end
end
