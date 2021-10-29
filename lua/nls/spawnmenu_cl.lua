local Spawnmenu = {}

NLS.Spawnmenu = Spawnmenu

local spawnmenu_node_nls

hook.Add("PopulateContent", "NLS_Spawnmenu", function(content_panel, tree, tree_node)
    local container = vgui.Create("ContentContainer", content_panel)
    container:SetVisible(false)

    spawnmenu_node_nls = tree:AddNode("#SERVER_NAME", "icon16/server.png")
    spawnmenu_node_nls.ContentContainer = container
    spawnmenu_node_nls.ContentPanel = content_panel
end)

-- DTree_Node -> string (name) -> DTree_Node
local NodeChildren = {}

-- 
-- returns: DTree_Node (with .ContentContainer and .ContentPanel)
local function GetCreateSubnode(root, name)
    assert(spawnmenu_node_nls, "PopulateContent hook was not called yet or failed!")
    
    local node_cache = NodeChildren[root]
    local node_cache_child = node_cache and node_cache[name]
    
    if node_cache_child ~= nil then
        return node_cache_child
    elseif node_cache == nil then
        node_cache = {}
        NodeChildren[root] = node_cache
    end

    local new_node = root:AddNode(name)
    new_node.ContentContainer = root.ContentContainer
    new_node.ContentPanel = root.ContentPanel

    node_cache[name] = new_node

    return new_node
end

local function GetSubnode(path)
    local cur_node = spawnmenu_node_nls

    for _, path_part in ipairs(path) do
        cur_node = cur_node[path_part]

        if cur_node == nil then
            return nil
        end
    end

    return cur_node
end

local function RemoveSubnodes(path)
    local node = GetSubnode(path)
    if node ~= nil then node:Clear() end
end

---- Custom file browser (LzWD-downloaded addons)

local ALLOWED_EXTENTIONS = {
    mdl = true,
    vmt = true,
    wav = true,
    mp3 = true,
    ogg = true
}

local function AddItemToTree(tree, path, item)
    for _, path_part in ipairs(path) do
        assert(path_part ~= "__value" and path_part ~= "__child_values")
        local subtree = tree[path_part] or {}
        tree[path_part] = subtree

        tree = subtree
    end

    tree.__value = item
end

local function FileListToTreeFiltered(files)
    local tree = {}

    for _, file in ipairs(files) do
        if not ALLOWED_EXTENTIONS[string.GetExtensionFromFilename(file)] then
            continue
        end

        local parts = string.Explode("/", file)
        AddItemToTree(tree, parts, file)
    end

    return tree
end

local function FlatTreeEnds(raw_tree)
    local result = {}
    local child_values = {}
    
    for k, v in pairs(raw_tree) do
        if k == "__value" then continue end

        if v.__value ~= nil then
            child_values[k] = v.__value
        end

        result[k] = FlatTreeEnds(v)
    end

    if table.IsEmpty(result) and table.IsEmpty(child_values) then
        return nil
    end

    result.__child_values = child_values
    return result
end

local function CreateContentItem(content_container, name, full_name)
    local ext = string.GetExtensionFromFilename(full_name)

    local icon_type
    local icon_opts

    if ext == "mdl" then
        icon_type = "model"
        icon_opts = { model = full_name }
    elseif ext == "vmt" then
        icon_type = "material"
        icon_opts = { spawnname = string.TrimLeft(full_name, "materials/"), nicename = name }
    elseif ext == "wav" or ext == "mp3" or ext == "ogg" then
        icon_type = "sound"
        icon_opts = { spawnname = string.TrimLeft(full_name, "sound/"), nicename = name }
    else
        Error("Invalid file extention: ",ext)
    end

    spawnmenu.CreateContentIcon(icon_type, content_container, icon_opts)
end

local function AddToSpawnmenu(node, tree)
    local tree_values = tree.__child_values

    if not table.IsEmpty(tree_values) then
        node.DoClick = function(node)
            local content_container = node.ContentContainer
            content_container:Clear()

            for name, full_name in SortedPairs(tree_values) do
                CreateContentItem(content_container, name, full_name)
            end

            node.ContentPanel:SwitchPanel(content_container)
        end
    end


    for name, subtree in pairs(tree) do
        if name == "__child_values" then continue end

        local subnode = GetCreateSubnode(node, name)
        AddToSpawnmenu(subnode, subtree)
    end
end

local FileRoots = {}

function Spawnmenu.AddFiles(root_name, files)
    local old_root = FileRoots[root_name]

    if old_root ~= nil then
        old_root.RootNode:Clear()
    end

    local root = {}

    local root_node = GetCreateSubnode(spawnmenu_node_nls, "Файлы")
    root_node = GetCreateSubnode(root_node, root_name)
    root.RootNode = root_node


    FileRoots[root_name] = root

    local raw_tree = FileListToTreeFiltered(files)
    local tree = FlatTreeEnds(raw_tree) or {__child_values = {}}

    root.Tree = tree

    AddToSpawnmenu(root_node, tree)
end