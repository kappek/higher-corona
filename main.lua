-- local composer= require ("composer")

-- composer.purgeOnSceneChange = true

-- composer.gotoScene ( "menu", { effect = "fade"} )


local background=display.newImage("Brick_Wall_Background.png")
display.setStatusBar(display.HiddenStatusBar)
background.x = display.contentCenterX
background.y = display.contentCenterY
local physics = require("physics")
local widget = require( "widget")
local game = display.newGroup();
local gameOverGroup = display.newGroup()
local char
local function round( num, idp)
	return tonumber(string.format("%."..(idp or 0) .. "f",num))
	-- body
end
physics.start()
i = -1
j = 0
k = 0
local listener1, listener3
local spawnTable = {}
local vertices = { -10,0, 0,0, 0,50, 50,50, 50,0, 60,0, 60,60, -10,60 }

local function listener2( obj )
	--print(obj.y)
	t2 = transition.to( obj, { time=(8000 - ((300-(obj.y))/220)*800 ), x=300, onComplete=listener1, onCancel = cancelListener3} )

    print( "Transition 2 completed on object: " .. tostring( obj ) )
end 
listener1 = function( obj )
	--print(i)
	-- print("iiii")
	-- print((300-(obj.y))/220)
	t1 = transition.to( obj, { time=8000 - ((300-(obj.y))/220)*800  , x=20, onComplete=listener2, onCancel = cancelListener2 } )
    print( "Transition 1 completed on object: " .. tostring( obj ) )
end 


local function spawn()
	i = i + 1

	local o = display.newPolygon( 160,300 - i*220, vertices )
	physics.addBody( o, "static", {bounce=0, friction=0 })
	--print(8000-((300-(o.y))/220)*200)
	transition.to( o, { time=(8000-((300-(o.y))/220)*800 ), x=300, onComplete=listener1, onCancel = cancelListener} )
	-- --spawnTable[i-1]:removeEventListener( "collision", onCollision )
	game:insert(o)
	--o:removeSelf()
	
	return object
end
local function spawnTwelve(x)
	 for j=x,x+6 do
	 	spawnTable[j] = spawn()
	 	
	 	--spawnTable[j]:removeSelf()
	 	--game:insert(spawnTable[j])
	 end
end

--scores
local score
local scoreDisplay = display.newText( "0", 0, 0, native.systemFont, 25 )
scoreDisplay.anchorX = 1	-- right
scoreDisplay.x = display.contentWidth - 25
scoreDisplay.y = 50
score = 0



-- spawn = function()
-- 	-- print("in spawn")
-- 	-- local object = display.newImageRect("crate.png", 40, 40)
-- 	-- object.x, object.y = 0, (240 - i*220)
-- 	-- game:insert(object);
-- 	-- physics.addBody( object, "static", {bounce=0, friction=0 })
-- 	-- object.collType = "passthrough"
-- 	-- transition.to( object, { time=(8000 /(i+1)), x=300, onComplete=listener1, onCancel = cancelListener} )
-- 	-- --spawnTable[i-1]:removeEventListener( "collision", onCollision )
-- 	i = i + 1

-- 	local o = display.newPolygon( 160,300 - i*220, vertices )
-- 	physics.addBody( o, "static", {bounce=0, friction=0 })
-- 	--print(8000-((300-(o.y))/220)*200)
-- 	transition.to( o, { time=(8000-((300-(o.y))/220)*800 ), x=300, onComplete=listener1, onCancel = cancelListener} )
-- 	-- --spawnTable[i-1]:removeEventListener( "collision", onCollision )
-- 	game:insert(o)
-- 	--o:removeSelf()
	
-- 	return object
-- end
-- spawnTwelve = function()
-- 	 for j=x,x+6 do
-- 	 	spawnTable[j] = spawn()
	 	
-- 	 	--spawnTable[j]:removeSelf()
-- 	 	--game:insert(spawnTable[j])
-- 	 end
-- end

temp = 2

local function onCollision( event )
	print("collision")
	if ( event.phase == "began" ) then
	  if(event.object1.y ~= temp) then
	  	flag = 1
	  end
	  temp = event.object1.y
      if(round((event.object1.y - event.object2.y),2) == 0.15 and flag == 1) then
      	score = score + 1
      	scoreDisplay.text=score
      	flag = 0
      end
    end
    if(score == 6) then
    	k = k+6
    	spawnTwelve(k)
    end
    --spawnTable[5]:removeSelf()

end


local function moveCamera()
	--print("called now")
	if (char.y < 240) then
		game.y = -char.y + 240
	end
	print(char.y)
	if(char.y>480) then
      print("Game over!"..char.y)
      --transition.cancel()
     gameOver()
     end
end



local function doJump( event )

	if ( "began" == event.phase ) then

		local diffX = event.x - char.x
		char:applyLinearImpulse( 0, -0.2, char.x, char.y )
	end
	return true
end



-- local touchRect = display.newRect( display.contentCenterX, display.contentCenterY, 600, 400 )
-- touchRect.isVisible = false
-- touchRect.isHitTestable = true
-- touchRect.anchorY = 0
-- touchRect:addEventListener( "touch", doJump )

--this is the gameover part

local function init(event)
	 gameOverGroup:removeSelf()
	 game.y = 0
	 --first crate
	 -- for j = 0,6 do
	 -- 	spawnTable[j]:removeSelf()
	 -- end
	 platform = display.newImageRect( "crate.png", 40, 40)
	 physics.addBody( platform, "static", { bounce=0, friction=0 } )
	 platform.myName = "platform"
	 platform.x, platform.y = 160, 480
	 game:insert(platform);
	 --ball
	 char = display.newImageRect( "char.png", 40, 40 )
	 game:insert(char);
	 char.x = 160; char.y = 400
	 physics.addBody( char, "dynamic", { radius=20, bounce=0, friction=0 })
	 char.myName = "char"
	 spawnTwelve(0)
	 Runtime:addEventListener( "enterFrame", moveCamera )
	 Runtime:addEventListener( "collision", onCollision )
	 Runtime:addEventListener( "touch", doJump )
end
local function init2(event)
	 gameOverGroup:removeSelf()
	 game.y = 0
	 --first crate
	 platform = display.newImageRect( "crate.png", 40, 40)
	 physics.addBody( platform, "static", { bounce=0, friction=0 } )
	 platform.myName = "platform"
	 platform.x, platform.y = 160, 480
	 game:insert(platform);
	 --ball
	 char = display.newImageRect( "char.png", 40, 40 )
	 game:insert(char);
	 char.x = 160; char.y = 400
	 physics.addBody( char, "dynamic", { radius=20, bounce=0, friction=0 })
	 char.myName = "char"
	 transition.resume()
	 --spawnTwelve()
	 Runtime:addEventListener( "enterFrame", moveCamera )
	 Runtime:addEventListener( "collision", onCollision )
	 Runtime:addEventListener( "touch", doJump )
end
function gameOver()
	char:removeSelf()
	platform:removeSelf()
	for j = 0,6 do
		local removeThis = table.remove(spawnTable,j)
	 	if removeThis ~= nil then
	 		display.remove(removeThis)
	 		removeThis = nil
	 	end
	end
	transition.pause()
	--table.remove(spawnTable)
    gameOverGroup = display.newGroup()
	Runtime:removeEventListener( "enterFrame", moveCamera )
    Runtime:removeEventListener("collision",onCollision)
    Runtime:removeEventListener( "touch", doJump )
 --    --touchRect:removeEventListener( "touch", doJump )
    local overGame = display.newImage("gameover_zpse663rlsp.png", 160, 240, true )
    gameOverGroup:insert(overGame)
    overGame.alpha = 0
    --overGame.xScale = 1.5; overGame.yScale = 1.5
    local showGameOver = transition.to( overGame, { alpha=1.0, xScale=1.0, yScale=1.0, time=500 } )
    --timer.performWithDelay(1000, init)
    overGame:addEventListener("touch",init2)
end
-- local composer = require( "composer" )
-- local scene = composer.newScene()

-- function scene:createScene( event )

-- end

-- function scene:enterScene( event )

-- end

-- function scene:exitScene( event )

-- end

-- function scene:destroyScene( event )

-- end

-- scene:addEventListener( "createScene", scene )
-- scene:addEventListener( "enterScene", scene )
-- scene:addEventListener( "exitScene", scene )
-- scene:addEventListener( "destroyScene", scene )

-- return scene
init()
