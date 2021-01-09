--========================================================--
--                Aim Default Skin                        --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2020/12/11                              --
--========================================================--

--========================================================--
Scorpio           "Aim.Skin.Default"                 "1.0.0"
--========================================================--

-----------------------------------------------------------
-- SHARE SETTINGS
-----------------------------------------------------------
BORDER_SIZE                     = 2
BAR_HEIGHT                      = 3
ICON_BORDER_SIZE                = 1

CLASSICFICATION_ELITE           = {
    elite                       = true,
    rare                        = true,
    rareelite                   = true,
    worldboss                   = true,
}

CASTBAR_NORMAL_COLOR            = Color.WHITE
CASTBAR_NONINTERRUPTIBLE_COLOR  = Color.DEATHKNIGHT

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
    -- Widget Template
    [ClassPowerBarElement]      = {
        SHARE_STATUSBAR_SKIN,

        autoHide                = false,
        autoFullValue           = true,
        statusBarColor          = Wow.ClassPowerColor(),
        backgroundFrame         = {
            backdropBorderColor = Wow.FromUIProperty("Activated"):Map(function(val) return val and Color.WHITE or  Color.BLACK end),
        },
    },

    -- Nameplate with Indicators
    [NamePlateUnitFrame]        = {
        location                = { Anchor("BOTTOMLEFT"), Anchor("BOTTOMRIGHT") },
        height                  = 300,

        NameLabel               = {
            drawLayer           = "OVERLAY",
            location            = { Anchor("BOTTOM", 0, 4, "HealthBar", "TOP") },
            textColor           = Wow.UnitExtendColor(),
            visible             = Wow.UnitIsPlayer(false),
        },
        LevelLabel              = {
            location            = { Anchor("RIGHT", -5, 0, "NameLabel", "LEFT") },
            visible             = Wow.UnitIsPlayer(false),
        },
        Label                   = {
            location            = { Anchor("LEFT", 0, 0, "LevelLabel", "RIGHT") },
            text                = Wow.UnitClassification():Map(function(state) return CLASSICFICATION_ELITE[state] and "+" or "" end),
            textColor           = Wow.UnitClassificationColor(),
        },
        HealthBar               = {
            SHARE_STATUSBAR_SKIN,

            location            = { Anchor("BOTTOMLEFT"), Anchor("BOTTOMRIGHT") },
            height              = BAR_HEIGHT,
            statusBarColor      = Wow.UnitExtendColor(true),
            value               = NIL,
            smoothValue         = Wow.UnitHealth(),
            backgroundFrame     = {
                backdropBorderColor = Wow.UnitIsTarget():Map(function(val) return val and Color.WHITE or  Color.BLACK end),
            },
        },
        PowerBar                = {
            SHARE_STATUSBAR_SKIN,

            location            = { Anchor("TOPLEFT", 0, -BORDER_SIZE, nil, "BOTTOMLEFT"), Anchor("RIGHT") },
            height              = BAR_HEIGHT,
            visible             = Wow.UnitIsPlayer(),
        },
        ClassPowerBar           = {
            frameStrata         = "LOW",
            enableMouse         = false,

            columnCount         = 8,
            rowCount            = 1,
            elementHeight       = BAR_HEIGHT,
            fixedWidth          = true,
            hSpacing            = BORDER_SIZE * 2 + 2,

            value               = Wow.ClassPower(),
            minMaxValues        = Wow.ClassPowerMax(),
            visible             = Wow.ClassPowerUsable(),

            location            = { Anchor("BOTTOMLEFT", 4, BORDER_SIZE + 1, "HealthBar", "TOPLEFT"), Anchor("BOTTOMRIGHT", -4, BORDER_SIZE + 1, "HealthBar", "TOPRIGHT") },
        },
        QuestMark               = {
            location            = { Anchor("RIGHT", -2, 0, "HealthBar", "LEFT")}
        },
        RaidTargetIcon          = {
            location            = { Anchor("LEFT", 2, 0, "HealthBar", "RIGHT") }
        },
        CastBar                 = {
            SHARE_STATUSBAR_SKIN,

            frameStrata         = "HIGH",
            statusBarColor      = Color.MAGE,

            height              = BAR_HEIGHT,
            location            = { Anchor("TOPLEFT", 0, -BORDER_SIZE, nil, "BOTTOMLEFT"), Anchor("RIGHT") },

            CooldownLabel       = {
                fontObject      = TextStatusBarText,
                location        = { Anchor("LEFT", 0, 0, nil, "RIGHT")},
                autoColor       = false,
                justifyH        = "LEFT",
                cooldown        = Wow.UnitCastCooldown(),
            },

            FontString          = {
                justifyH        = "CENTER",
                drawLayer       = "OVERLAY",
                fontObject      = GameFontHighlight,
                location        = { Anchor("CENTER") },
                text            = Wow.UnitCastName(),
            },

            SecondFontString    = {
                justifyH        = "LEFT",
                drawLayer       = "OVERLAY",
                fontObject      = GameFontHighlight,
                location        = { Anchor("LEFT", 0, 0, "CooldownLabel", "RIGHT") },
                textColor       = Color.RED,
                text            = Wow.UnitCastDelay():Map(function(delay) return delay and delay > 0 and ("(+%.1f)"):format(delay) or "" end),
            },

            IconFrame           = {
                size            = Size(16, 16),
                location        = { Anchor("RIGHT", -2, BAR_HEIGHT, nil, "LEFT") },
                frameStrata     = "BACKGROUND",
                backdrop        = {
                    edgeFile    = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
                    edgeSize    = ICON_BORDER_SIZE,
                },
                backdropBorderColor = Wow.UnitCastInterruptible():Map(function(val) return val and CASTBAR_NORMAL_COLOR or CASTBAR_NONINTERRUPTIBLE_COLOR end),

                IconTexture     = {
                    file        = Wow.UnitCastIcon(),
                    location    = { Anchor("TOPLEFT", ICON_BORDER_SIZE, -ICON_BORDER_SIZE), Anchor("BOTTOMRIGHT", -ICON_BORDER_SIZE, ICON_BORDER_SIZE) },
                    texCoords   = RectType(0.1, 0.9, 0.1, 0.9),
                }
            },
        },
    },
})