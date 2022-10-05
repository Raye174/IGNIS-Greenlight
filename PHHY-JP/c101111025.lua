--サークル・オブ・フェアリー
--Hexenringe Master Faeri
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	-- Can be used as a non-Tuner for the Synchro Summon of a Plant/Insect monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(s.ntval)
	c:RegisterEffect(e2)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_PLANT|RACE_INSECT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.ntval(c,sc,tp)
	return sc and sc:IsRace(RACE_PLANT|RACE_INSECT)
end