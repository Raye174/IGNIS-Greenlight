--Ｒｅｃｅｔｔｅ ｄｅ Ｖｉａｎｄｅ～肉料理のレシピ～
--Recette de Viande - Meat Recipe
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	-- Ritual Summon any "Nouvellez" monster
	local e1=Ritual.AddProcGreater({handler=c,filter=aux.FilterBoolFunction(Card.IsSetCard,SET_NOUVELLEZ),
		stage2=s.stage2,extratg=s.extratg})
	e1:SetCategory(e1:GetCategory()|CATEGORY_POSITION)
end
s.listed_series={SET_NOUVELLEZ}
s.listed_names={100430030} --Confitras de Nouvellez
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if not tc:IsCode(100430030) then return end
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end