--[[
   This is a table of functions, that when called with an area and center position, will spawn different ruins.
   If you want to add more ruins, simply observe the format, and create it accordingly.
   Remember that the server must also share this config, exactly, to prevent desyncs.
   Format:

   function(area,center)
   --code to spawn entities relative to the center
   end,

--]]

--checks for spawning validity and if valid, clears space for the spawn
function s_clearArea(center)
   for y = center.y, center.y+6 do --fail if any water in area
      for x = center.x, center.x+6 do
         if game.surfaces[1].get_tile(x,y).name == "water" or game.surfaces[1].get_tile(x,y).name == "deepwater" then
            return false
         end
      end
   end

   for index,entity in pairs(game.surfaces[1].find_entities({{center.x-4,center.y-4},{center.x+4,center.y+4}})) do
      entity.destroy()
   end
   return true
end

local s_ruins = {
   function(center) --land mine bunker

      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name="stone-wall",position={center.x-2,center.y},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x-2,center.y-1},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x-2,center.y-2},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+1,center.y-1},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y-2},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y-1},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y+1},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y+2},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+2,center.y+3},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x+1,center.y+3},force=game.forces.neutral}
      ce{name="stone-wall",position={center.x,center.y+3},force=game.forces.neutral}

      ce{name="land-mine",position={center.x,center.y},force=game.forces.enemy} --trap

   end,
   function(center)  --small smelting station
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name="stone-furnace",position={center.x-2,center.y-2},force=game.forces.neutral}
      local chest = ce{name="wooden-chest",position={center.x,center.y-1},force=game.forces.neutral}
      chest.insert{name="coal",count=5}
      chest.insert{name="iron-ore",count=20}
   end,
   function(center) --small destroyed setup
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name="assembling-machine-1",position={center.x+0.5,center.y+2.5},force=game.forces.neutral}.damage(150,"neutral","physical")
      ce{name="inserter",position={center.x+2.5,center.y+1.5},force=game.forces.neutral}.damage(25,"neutral","physical")
      ce{name="inserter",position={center.x+0.5,center.y-1.5},force=game.forces.neutral}.damage(17,"neutral","physical")

      ce{name="transport-belt",position={center.x-1.5,center.y+1},force=game.forces.neutral}.damage(25,"neutral","physical")
      ce{name="transport-belt",position={center.x-1.5,center.y},force=game.forces.neutral}
      ce{name="transport-belt",position={center.x-1.5,center.y-1},force=game.forces.neutral}.damage(15,"neutral","physical")
   end,

}

function spawnSmallRuins(center)
   game.surfaces[1].set_tiles({{name="concrete",position=center}})
   s_ruins[math.random(#s_ruins)](center) --call a random function
end
