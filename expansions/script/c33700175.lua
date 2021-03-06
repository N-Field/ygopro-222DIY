--朱雀的净化
function c33700175.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c33700175.cost)
	e2:SetTarget(c33700175.tg)
	e2:SetOperation(c33700175.op)
	c:RegisterEffect(e2)
   --draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700175,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1) 
	e3:SetCondition(c33700175.thcon)
	e3:SetTarget(c33700175.thtg)
	e3:SetOperation(c33700175.thop)
	c:RegisterEffect(e3)
end
function c33700175.filter(c)
	return c:IsCode(33700083) and c:IsAbleToRemoveAsCost()
end
function c33700175.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700175.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33700175.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33700175.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c33700175.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SSet(tp,c)
	end
end
function c33700175.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c33700175.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c33700175.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct1=Duel.GetFieldGroupCount(p,0,LOCATION_HAND)
	local ct2=ct1-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct2,REASON_EFFECT)
	end
	local sg=Duel.GetOperatedGroup()
	 Duel.ConfirmCards(1-p,sg)
	if  sg:GetClassCount(Card.GetCode)==sg:GetCount() then
	local gt=FilterSelect(p,Card.IsDiscardable,1,sg:GetCount(),nil)
	Duel.SendtoGrave(gt,REASON_EFFECT+REASON_DISCARD)
	local ct3=gt:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,p,LOCATION_GRAVE,0,nil)
	if ct3>0 and tg:GetCount()>=ct3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sel=tg:Select(p,ct3,ct3,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sel)
	end
	else
   Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
end