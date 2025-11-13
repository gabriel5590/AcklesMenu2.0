local imgui = require("mimgui")

local menu_active = imgui.new.bool(true)
local teste = imgui.new.bool(false)
local esp_toggle = imgui.new.bool(false)
local esp_name = false

function imgui.Theme()
  imgui.SwitchContext()
  imgui.GetStyle().FrameRounding = 3
  imgui.GetStyle().FramePadding = imgui.ImVec2(20,8)
  imgui.GetStyle().ChildRounding = 2
  imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5,0.5)
  imgui.GetStyle().WindowPadding = imgui.ImVec2(4.0,4.0)
  imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0,0.5)
  imgui.GetStyle().WindowRounding = 2
  imgui.GetStyle().ItemSpacing = imgui.ImVec2(5.0,4.0)
  -- colors
  imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(1,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.8,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.TabActive] =  imgui.ImVec4(0.8,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.8,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.8,0,0,1)
  imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.8,0,0,1
  )
end

imgui.OnInitialize(function()
  imgui.Theme() end)

function esps()
  if esp_name then
    local myx,myy,myz = getCharCoordinates(PLAYER_PED)
    local mx,my = convert3DCoordsToScreen(myx,myy,myz)
    local font = renderCreateFont("Arial", 16, 0)
    for id = 0, 400 do
      local result, ped = sampGetCharHandleBySampPlayerId(id)
      if result and doesCharExist(ped) then
        local name = sampGetPlayerNickname(id)
        local text = string.format("%s", name)
        local x,y,z = getCharCoordinates(ped)
        local sx,sy = convert3DCoordsToScreen(x,y,z)
        if isPointOnScreen(x,y,z,1) then
          renderFontDrawText(font, text, sx,sy, 0xFFFF0000)
          renderDrawLine(mx,my,sx,sy,1.0,0xFFFF0000)
        end
      end
    end
  end
end
    
imgui.OnFrame(
    function()
      return true
    end,
    function(player)
      if menu_active[0] then
        if imgui.Begin('Ackles Menu', teste) then
          if imgui.BeginTabBar('Tabs') then
            if imgui.BeginTabItem('ESP') then
              if imgui.Checkbox("Esp Name", esp_toggle) then
                esp_name = esp_toggle[0]
                if esp_name then
                  sampAddChatMessage("Esp Name Ativo", 0xFFFF0000)
                else
                  sampAddChatMessage("Esp Name Desativo", 0xFFFF0000)
                end
              end
            end
          end
        end
      end
    imgui.End()
    end)

sampRegisterChatCommand("ackles", function()
  menu_active[0] = true end)

function main()
  while not isSampAvailable() do wait(0) end
  while true do
    esps()
    wait(0)
  end
end
