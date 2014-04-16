local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)			
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)			
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)		
end
function onThink()
	npcHandler:onThink()					
end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	
	local player = Player(cid)
	if msgcontains(msg, "Hydra Tongue") then
		npcHandler:say("Do you want to buy a Hydra Tongue for 100 gold?", player)
		talkState[talkUser] = 1
	elseif msgcontains(msg, "yes") then
		if talkState[talkUser] == 1 then
			if player:getMoney() >= 100 then
				player:removeMoney(100)
				npcHandler:say("Here you are. A Hydra Tongue!", player)
				player:addItem(7250, 1)
				talkState[talkUser] = 0
			else
				npcHandler:say("You don't have enough money.", player)
			end
		end
	elseif msgcontains(msg, "no") then
		if talkState[talkUser] == 1 then
			npcHandler:say("Then not.", player)
			talkState[talkUser] = 0
		end
	end
	return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())