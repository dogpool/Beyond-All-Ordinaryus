
local widget = widget ---@type Widget

function widget:GetInfo()
	return {
		name	= "AdvPlayersList Unit Totals",
		desc	= "Displays number of units",
		author	= "Floris",
		date	= "december 2019",
		license	= "GNU GPL, v2 or later",
		layer	= -3,
		enabled	= false,
	}
end

local useRenderToTexture = Spring.GetConfigFloat("ui_rendertotexture", 1) == 1		-- much faster than drawing via DisplayLists only

local displayFeatureCount = false

local vsx, vsy = Spring.GetViewGeometry()

local widgetScale = 1
local glPushMatrix   = gl.PushMatrix
local glPopMatrix    = gl.PopMatrix
local glCreateList   = gl.CreateList
local glDeleteList   = gl.DeleteList
local glCallList     = gl.CallList

local spGetTeamUnitCount = Spring.GetTeamUnitCount

local RectRound, UiElement, elementCorner
local font

local drawlist = {}
local advplayerlistPos = {}
local widgetHeight = 22
local top, left, bottom, right = 0,0,0,0

local myTeamID = Spring.GetMyTeamID()
local totalUnits = 0
local passedTime = 0

local allyTeamList = Spring.GetAllyTeamList()
local allyTeamTeamList = {}
for i = 1, #allyTeamList do
	allyTeamTeamList[allyTeamList[i]] = Spring.GetTeamList(allyTeamList[i])
end



local function drawBackground()
	UiElement(left, bottom, right, top, 1,0,0,1, 1,1,0,1, nil, nil, nil, nil)
end

local function drawContent()
	local textsize = 11*widgetScale * math.clamp(1+((1-(vsy/1200))*0.4), 1, 1.15)
	local textXPadding = 10*widgetScale

	local maxUnits, currentUnits = Spring.GetTeamMaxUnits(myTeamID)
	local text = Spring.I18N('ui.unitTotals.totals', { titleColor = '\255\210\210\210', textColor = '\255\245\245\245', units = currentUnits, maxUnits = maxUnits, totalUnits = totalUnits })

	if displayFeatureCount then
		local features = Spring.GetAllFeatures()
		text = text..'    \255\170\170\170'..#features
	end
	font:Begin(useRenderToTexture)
	font:SetOutlineColor(0.15,0.15,0.15,0.8)
	font:Print(text, left+textXPadding, bottom+(0.48*widgetHeight*widgetScale)-(textsize*0.35), textsize, 'no')
	font:End()
end

local function refreshUiDrawing()
	if WG['guishader'] then
		if guishaderList then
			guishaderList = glDeleteList(guishaderList)
		end
		guishaderList = glCreateList( function()
			RectRound(left, bottom, right, top, elementCorner, 1,0,0,1)
		end)
		WG['guishader'].InsertDlist(guishaderList, 'unittotals', true)
	end

	if right-left >= 1 and top-bottom >= 1 then
		if useRenderToTexture then
			if not uiBgTex then
				uiBgTex = gl.CreateTexture(math.floor(right-left), math.floor(top-bottom), {
					target = GL.TEXTURE_2D,
					format = GL.RGBA,
					fbo = true,
				})
				gl.R2tHelper.RenderToTexture(uiBgTex,
					function()
						gl.Translate(-1, -1, 0)
						gl.Scale(2 / (right-left), 2 / (top-bottom), 0)
						gl.Translate(-left, -bottom, 0)
						drawBackground()
					end,
					useRenderToTexture
				)
			end
		else
			if drawlist[1] ~= nil then
				glDeleteList(drawlist[1])
			end
			drawlist[1] = glCreateList( function()
				drawBackground()
			end)
		end
		if useRenderToTexture then
			if not uiTex then
				uiTex = gl.CreateTexture(math.floor(right-left), math.floor(top-bottom), {		--*(vsy<1400 and 2 or 1)
					target = GL.TEXTURE_2D,
					format = GL.RGBA,
					fbo = true,
				})
			end
			gl.R2tHelper.RenderToTexture(uiTex,
				function()
					gl.Translate(-1, -1, 0)
					gl.Scale(2 / (right-left), 2 / (top-bottom), 0)
					gl.Translate(-left, -bottom, 0)
					drawContent()
				end,
				useRenderToTexture
			)
		else
			if drawlist[2] ~= nil then
				glDeleteList(drawlist[2])
			end
			drawlist[2] = glCreateList( function()
				drawContent()
			end)
		end
	end
end

local function updatePosition(force)
	local prevPos = advplayerlistPos
	if WG['music'] and WG['music'].GetPosition and WG['music'].GetPosition() then
		advplayerlistPos = WG['music'].GetPosition()
	elseif WG['advplayerlist_api'] ~= nil then
		advplayerlistPos = WG['advplayerlist_api'].GetPosition()
	else
		local scale = (vsy / 880) * (1 + (Spring.GetConfigFloat("ui_scale", 1) - 1) / 1.25)
		advplayerlistPos = {0,vsx-(220*scale),0,vsx,scale}
	end
	left = advplayerlistPos[2]
	bottom = advplayerlistPos[1]
	right = advplayerlistPos[4]
	top = math.ceil(advplayerlistPos[1]+(widgetHeight*advplayerlistPos[5]))
	widgetScale = advplayerlistPos[5]
	if (prevPos[1] == nil or prevPos[1] ~= advplayerlistPos[1] or prevPos[2] ~= advplayerlistPos[2] or prevPos[5] ~= advplayerlistPos[5]) or force then
		widget:ViewResize()
	end
end

function widget:Initialize()
	widget:ViewResize()
	updatePosition()
	WG['unittotals'] = {}
	WG['unittotals'].GetPosition = function()
		return {top,left,bottom,right,widgetScale}
	end
end

function widget:PlayerChanged()
	myTeamID = Spring.GetMyTeamID()
end

function widget:Shutdown()
	if WG['guishader'] then
		WG['guishader'].RemoveDlist('unittotals')
	end
	for i=1,#drawlist do
		glDeleteList(drawlist[i])
	end
	if guishaderList then glDeleteList(guishaderList) end
	if uiTex then
		gl.DeleteTexture(uiBgTex)
		uiBgTex = nil
		gl.DeleteTexture(uiTex)
		uiTex = nil
	end
	WG['unittotals'] = nil
end

function widget:Update(dt)
	updatePosition()
	passedTime = passedTime + dt
	if passedTime > 1 and Spring.GetGameFrame() > 0 then
		totalUnits = 0
		local numberOfAllyTeams = #allyTeamList
		for allyTeamListIndex = 1, numberOfAllyTeams do
			local allyID = allyTeamList[allyTeamListIndex]
			for _,teamID in pairs(allyTeamTeamList[allyID]) do
				totalUnits = totalUnits + spGetTeamUnitCount(teamID)
			end
		end
		updateDrawing = true
		passedTime = passedTime - 1
	end
end

function widget:ViewResize()
	vsx, vsy = Spring.GetViewGeometry()

	font = WG['fonts'].getFont()

	elementCorner = WG.FlowUI.elementCorner
	RectRound = WG.FlowUI.Draw.RectRound
	UiElement = WG.FlowUI.Draw.Element

	updateDrawing = true
	if uiTex then
		gl.DeleteTexture(uiBgTex)
		uiBgTex = nil
		gl.DeleteTexture(uiTex)
		uiTex = nil
	end
end

function widget:DrawScreen()
	if updateDrawing then
		updateDrawing = false
		refreshUiDrawing()
	end

	if useRenderToTexture then
		if uiBgTex then
			-- background element
			gl.R2tHelper.BlendTexRect(uiBgTex, left, bottom, right, top, useRenderToTexture)
		end
	end
	if useRenderToTexture then
		if uiTex then
			-- content
			gl.R2tHelper.BlendTexRect(uiTex, left, bottom, right, top, useRenderToTexture)
		end
	else
		if drawlist[2] then
			glPushMatrix()
			if not useRenderToTexture and drawlist[1] then
				glCallList(drawlist[1])
			end
			glCallList(drawlist[2])
			glPopMatrix()
		end
	end
end
