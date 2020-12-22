--========================================================--
--                Aim Default Skin                        --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2020/12/11                              --
--========================================================--

--========================================================--
Scorpio           "Aim.Skin.Default"                 "1.0.0"
--========================================================--

BORDER_SIZE                     = 2

SHARE_STATUSBAR_SKIN            = {
    statusBarTexture            = {
        file                    = [[Interface\Buttons\WHITE8x8]]
    },
    backgroundFrame             = {
        frameStrata             = "BACKGROUND",
        location                = { Anchor("TOPLEFT", -BORDER_SIZE, BORDER_SIZE), Anchor("BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE) },
        backgroundTexture       = {
            drawLayer           = "BACKGROUND",
            setAllPoints        = true,
            color               = Color(0.2, 0.2, 0.2, 0.8),
        },
        backdrop                = {
            edgeFile            = [[Interface\Buttons\WHITE8x8]],
            edgeSize            = BORDER_SIZE,
        },
        backdropBorderColor     = Color.BLACK,
    },
}

-----------------------------------------------------------
-- Default Indicator and Style settings
-----------------------------------------------------------
Style.UpdateSkin("Default",     {
    [NamePlateUnitFrame]        = {
        location                = { Anchor("BOTTOMLEFT"), Anchor("BOTTOMRIGHT") },
        height                  = 300,

        NameLabel               = {
            drawLayer           = "OVERLAY",
            location            = { Anchor("BOTTOM", 0, 0, "HealthBar", "TOP") },
            textColor           = Wow.UnitExtendColor(),
        },
        HealthBar               = {
            SHARE_STATUSBAR_SKIN,

            location            = { Anchor("BOTTOMLEFT"), Anchor("BOTTOMRIGHT") },
            height              = BORDER_SIZE,
            statusBarColor      = Wow.UnitExtendColor(true),
        },
        QuestMark               = {
            location            = { Anchor("RIGHT", -2, 0, "HealthBar", "LEFT")}
        },
    }
})