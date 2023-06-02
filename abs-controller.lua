-- this microcontroller program is to automate removing programmed circuits [and control tokens] from an input bus / transvector interface, while watching a fluid input hatch
-- when fluid input hatch (if applicable) is empty, AND
-- input bus is empty EXCEPT FOR 'target' and 'token' (if applicable)
-- then it transfers 'target' and then 'token' back into the ME interface.

	local tp = component.proxy(component.list("transposer")())

	-- target: string to find inside the name of the item[s]
	local targetName = "Mold (";	-- matches all fluid solidifier molds
	-- alternate:      "programmed circuit"
	
	-- token: the workaround to blocking mode not working for dual interfaces in non-dev.
	-- Set up your AE system with 1 unique token item (and a crafting recipe of 1 stone dust into a trash can = 1 token)
	-- then include this token in your recipes.
	-- Result: makeshift blocking mode, as the system cannot try to craft multiple recipes at a time that use the same token
	-- (but it can still queue them, because of your dummy trash->token recipe, which gets fulfilled by this program returning the 1 token)
	local expectToken = true;
	local tokenName = "alloy blast smelter token";
	
	function GetSides()
		local inputBus;
		local inputHatch;
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
				if next(tp.getFluidInTank(side)) 
				and not string.find(name, "fluid_interface") then
					inputHatch = side;
				elseif string.find(name, "blockinterface")
				or string.find(name, "fluid_interface") then
					meInterface = side;
				elseif string.find(name, "gt.blockmachines")
				or     string.find(name, "tile.interface") then
					inputBus = side;
				end
			end
		end
	
		return inputBus, inputHatch, meInterface;
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
	
	function HasFluid(inputHatch)
		if inputHatch == nil then return false end
		return tp.getFluidInTank(side)[0].amount > 0;
	end
	
	-----------------------------------------------------------------------------------
	-- PROGRAM STARTS HERE
	
	-- get sides
	local inputBus, inputHatch, meInterface = GetSides();
	
	-- MAIN LOOP
	while true do
		local items = tp.getAllStacks(inputBus);
		if (ItemCount(items) <= (expectToken and 2 or 1)) and not (HasFluid(inputHatch)) then
			TransferItemByName(inputBus, meInterface, targetName);
			if (expectToken) then
				TransferItemByName(inputBus, meInterface, tokenName);
			end
		end
	end
	