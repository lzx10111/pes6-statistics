local FormCreatorJsonViewer = {}

function FormCreatorJsonViewer.build(parentForm)
    local frmJsonViewer = createForm(false)
    frmJsonViewer.Name = "frmJsonViewer"
    frmJsonViewer.Caption = "Extra: JSON String Viewer"
    frmJsonViewer.Width = 500
    frmJsonViewer.Height = 600

    if parentForm then
        frmJsonViewer.Position = "poOwnerFormCenter"
        ---@diagnostic disable-next-line: undefined-field
        pcall(function() frmJsonViewer.setOwner(parentForm) end)
    else
        frmJsonViewer.Position = "poScreenCenter"
    end

    ---@diagnostic disable-next-line: undefined-global
    local jsonMemo = createMemo(frmJsonViewer)
    jsonMemo.Name = "jsonMemo"
    jsonMemo.Parent = frmJsonViewer
    jsonMemo.Align = alTop
    jsonMemo.Height = 130
    jsonMemo.Font.Name = "Consolas"
    jsonMemo.Font.Size = 10

    ---@diagnostic disable-next-line: undefined-global
    local treeView = createTreeView(frmJsonViewer)
    treeView.Name = "treeView"
    treeView.Parent = frmJsonViewer
    treeView.Align = alClient
    treeView.ReadOnly = true
    treeView.Font.Size = 10

    return frmJsonViewer
end

return FormCreatorJsonViewer