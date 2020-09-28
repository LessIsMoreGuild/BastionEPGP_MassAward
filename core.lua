BastionEPGP_MassAward = LibStub("AceAddon-3.0"):NewAddon("BastionEPGP_MassAward", "AceConsole-3.0")
local GUI = LibStub("AceGUI-3.0")
local C = LibStub("LibCrayon-3.0")
local ST = LibStub("ScrollingTable")

local bepgp = BastionEPGP
ep_store = 50

function award_ep()
   for name, _ in pairs(award_table) do
      if award_table[name] then
         --print("Awarding "..ep_store.." ep".." to "..name)
         BastionEPGP:givename_ep(name, ep_store, true)
      end
   end
end


BastionEPGP_MassAward:RegisterChatCommand("mass", "massawardFunc")

function BastionEPGP_MassAward:massawardFunc(input)
  award_table = {}
  local container = GUI:Create("Window")
  container:SetTitle("BastionEPGP reward ep")
  container:SetLayout("Flow")
  container:SetCallback("OnClose", function(widget) GUI:Release(widget) end)

  local editbox = GUI:Create("EditBox")
  editbox:SetLabel("EPs:")
  editbox:SetWidth(100)
  editbox:SetHeight(40)
  editbox:SetText(ep_store)
  editbox:SetCallback("OnEnterPressed", function(widget, event, text)
    ep = tonumber(text)
    if ep then
     ep_store = ep
    else
      print("Not a valid Number")
      editbox:SetText(ep_store)
    end
  end)
  container:AddChild(editbox)

  local award = GUI:Create("Button")
  award:SetAutoWidth(true)
  award:SetText("Award")
  award:SetCallback("OnClick", function() award_ep() end)
  container:AddChild(award)

  local desc = GUI:Create("Label")
  desc:SetText(" Currently selected: "..tostring(0))
  desc:SetFullWidth(true)
  container:AddChild(desc)

  scrollcontainer = GUI:Create("InlineGroup") -- "InlineGroup" is also good
  scrollcontainer:SetFullWidth(true)
  scrollcontainer:SetFullHeight(true) -- probably?
  scrollcontainer:SetLayout("Fill") -- important!

  container:AddChild(scrollcontainer)

  scroll = GUI:Create("ScrollFrame")
  scroll:SetLayout("Flow") -- probably?
  scrollcontainer:AddChild(scroll)

  bepgp:make_escable(container,"add")

  local members = bepgp:buildRosterTable()
  for k,v in pairs(members) do
    local ep = bepgp:get_ep(v.name,v.onote) or 0
    if ep > 0 then
        local cb = GUI:Create("CheckBox")
        cb:SetLabel(v.name)
        cb:SetCallback("OnValueChanged", function(widget,callback,value)
              award_table[v.name] = value
              selection_count = 0
              for name, _ in pairs(award_table) do
                if award_table[name] then
                   selection_count = selection_count + 1
                end
              end
              desc:SetText(" Currently selected: "..tostring(selection_count))
        end)
        scroll:AddChild(cb)
        --end
    end
  end
end


function BastionEPGP_MassAward:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
end

function BastionEPGP_MassAward:OnEnable()
  -- Called when the addon is enabled
end

function BastionEPGP_MassAward:OnDisable()
  -- Called when the addon is disabled
end




