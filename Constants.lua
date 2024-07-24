
local name, addon = ...;

HearthstoneLite = {}
HearthstoneLite.Constants = {}
HearthstoneLite.Constants.DefaultBackground = "completiondialog-dragonflightcampaign-background"
HearthstoneLite.Constants.CursorCard = false;


HearthstoneLite.Constants.NineSliceLayouts = {
    ListviewMetal = {
        TopLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopLeft", x=-15, y=15 },
        TopRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopRight", x=15, y=15 },
        BottomLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomLeft", x=-15, y=-15 },
        BottomRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomRight", x=15, y=-15 },
        TopEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeBottom", },
        LeftEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeRight", },
        Center = { layer = "BACKGROUND", atlas = "ClassHall_InfoBoxMission-BackgroundTile", x = -20, y = 20, x1 = 20, y1 = -20 },
    },
    DeckListviewItem = {
        ["TopRightCorner"] = { atlas = "Tooltip-NineSlice-CornerTopRight" },
		["TopLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerTopLeft" },
		["BottomLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomLeft" },
		["BottomRightCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomRight" },
		["TopEdge"] = { atlas = "_Tooltip-NineSlice-EdgeTop" },
		["BottomEdge"] = { atlas = "_Tooltip-NineSlice-EdgeBottom" },
		["LeftEdge"] = { atlas = "!Tooltip-NineSlice-EdgeLeft" },
		["RightEdge"] = { atlas = "!Tooltip-NineSlice-EdgeRight" },
    }
}