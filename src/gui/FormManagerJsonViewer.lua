local FormEventsJsonViewer = _G.Classes.FormEventsJsonViewer
local FormManagerJsonViewer = {
    form = nil,
    components = {}
}

function FormManagerJsonViewer:init(ceForm)
    self.form = ceForm
    self:mapComponents()
    self:setupEvents()
end

function FormManagerJsonViewer:mapComponents()
    self.components.jsonMemo = self.form["jsonMemo"]
    self.components.treeView = self.form["treeView"]
end

function FormManagerJsonViewer:setupEvents()
    self.form.OnClose = function()
        return FormEventsJsonViewer.onFormClose()
    end
end

function FormManagerJsonViewer:loadJsonString(jsonString, command)
    command = command or nil

    if self.components.jsonMemo then
        self.components.jsonMemo.lines.text = jsonString or "{\n}"
        FormEventsJsonViewer.onBtnParseClick(self, command, jsonString)
    end
end

function FormManagerJsonViewer:preLoadJsonString()
    local staticWarmupJson = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50]"

    FormManagerJsonViewer:loadJsonString(staticWarmupJson)
end

return FormManagerJsonViewer