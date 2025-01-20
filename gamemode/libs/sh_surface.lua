if not ( CLIENT ) then return end

impulse.Surface = impulse.Surface or {}
impulse.Surface.Data = impulse.Surface.Data or {}

function impulse.Surface.DefineTypeFace(fontFace, offsetx, offsety, alpha)
	offsetx = offsetx or 2
	offsety = offsety or 2
	alpha = alpha or 255

	impulse.Surface.Data[fontFace] = {
		oX = offsetx,
		oY = offsety,
		fO = alpha
	}
end
hook.Add("PostLoadFonts", "newFonts", function()
    surface.CreateFont("Impulse-Elements18", {
        font = "DINPro-Light",
        size = 18,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements19", {
        font = "DINPro-Light",
        size = 19,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements16", {
        font = "DINPro-Light",
        size = 16,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements17", {
        font = "DINPro-Light",
        size = 17,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements17-Shadow", {
        font = "DINPro-Light",
        size = 17,
        weight = 800,
        antialias = true,
        shadow = true
    } )

    surface.CreateFont("Impulse-Elements14", {
        font = "DINPro-Light",
        size = 14,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements14-Shadow", {
        font = "DINPro-Light",
        size = 14,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements18-Shadow", {
        font = "DINPro-Light",
        size = 18,
        weight = 900,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements16-Shadow", {
        font = "DINPro-Light",
        size = 16,
        weight = 900,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements19-Shadow", {
        font = "DINPro-Light",
        size = 19,
        weight = 900,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements20-Shadow", { -- dont change this font to actually be 20 its a dumb mistake
        font = "DINPro-Light",
        size = 18,
        weight = 900,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements20A-Shadow", { -- dont change this font to actually be 20 its a dumb mistake
        font = "DINPro-Light",
        size = 20,
        weight = 900,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-CharacterInfo", {
        font = "DINPro-Light",
        size = 34,
        weight = 900,
        antialias = true,
        shadow = true,
        outline = true
    } )

    surface.CreateFont("Impulse-CharacterInfo-NO", {
        font = "DINPro-Light",
        size = 34,
        weight = 900,
        antialias = true,
        shadow = true,
        outline = false
    } )

    surface.CreateFont("Impulse-Elements13", {
        font = "DINPro-Light",
        size = 18,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements22-Shadow", {
        font = "DINPro-Light",
        size = 22,
        weight = 700,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements72-Shadow", {
        font = "DINPro-Light",
        size = 72,
        weight = 700,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements23", {
        font = "DINPro-Light",
        size = 23,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements23-Shadow", {
        font = "DINPro-Light",
        size = 23,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements23-Italic", {
        font = "DINPro-Light",
        size = 23,
        weight = 800,
        italic = true,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements24-Shadow", {
        font = "DINPro-Light",
        size = 24,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements27-Shadow", {
        font = "DINPro-Light",
        size = 27,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements27", {
        font = "DINPro-Light",
        size = 27,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements32", {
        font = "DINPro-Light",
        size = 32,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements33", {
        font = "DINPro-Light",
        size = 33,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements34", {
        font = "DINPro-Light",
        size = 34,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements34-Shadow", {
        font = "DINPro-Light",
        size = 34,
        weight = 800,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements35", {
        font = "DINPro-Light",
        size = 35,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements32-Shadow", {
        font = "DINPro-Light",
        size = 32,
        weight = 800,
        antialias = true,
        shadow = true
    } )

    surface.CreateFont("Impulse-Elements36", {
        font = "DINPro-Light",
        size = 36,
        weight = 800,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements48", {
        font = "DINPro-Light",
        size = 48,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements48-Shadow", {
        font = "DINPro-Light",
        size = 48,
        weight = 1000,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-Elements49", {
        font = "DINPro-Light",
        size = 49,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements50", {
        font = "DINPro-Light",
        size = 50,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements50-Shadow", {
        font = "DINPro-Light",
        size = 50,
        weight = 1000,
        antialias = true,
        shadow = true,
    } )
    surface.CreateFont("Impulse-Elements51", {
        font = "DINPro-Light",
        size = 51,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements52", {
        font = "DINPro-Light",
        size = 52,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements52-Shadow", {
        font = "DINPro-Light",
        size = 52,
        weight = 1000,
        antialias = true,
        shadow = true,
    } )


    surface.CreateFont("Impulse-Elements78", {
        font = "DINPro-Light",
        size = 78,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-Elements108", {
        font = "DINPro-Light",
        size = 108,
        weight = 1000,
        antialias = true,
        shadow = false,
    } )

    surface.CreateFont("Impulse-ChatSmall", {
        font = "DINPro-Light",
        size = (impulse.IsHighRes() and 20 or 16),
        weight = 700,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-ChatMedium", {
        font = "DINPro-Light",
        size = (impulse.IsHighRes() and 21 or 17),
        weight = 700,
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-ChatRadio", {
        font = "Consolas",
        size = (impulse.IsHighRes() and 24 or 17),
        weight = (impulse.IsHighRes() and 700 or 500),
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-ChatLarge", {
        font = "DINPro-Light",
        size = (impulse.IsHighRes() and 27 or 20),
        weight = (impulse.IsHighRes() and 1100 or 700),
        antialias = true,
        shadow = true,
    } )

    surface.CreateFont("Impulse-UI-SmallFont", {
        font = "DINPro-Light",
        size = math.max(ScreenScale(6), 17),
        extended = true,
        weight = 500
    })

    surface.CreateFont("Impulse-SpecialFont", {
        font = "DINPro-Light",
        size = 33,
        weight = 3700,
        antialias = true,
        shadow = true
    })

    surface.CreateFont("Impulse-LightUI128", {
        font = "DINPro-Light",
        size = 128,
        weight = 100,
        antialias = true,
        blursize = 0
    })

    surface.CreateFont("Impulse-LightUI128-Blurred", {
        font = "DINPro-Light",
        size = 128,
        weight = 100,
        antialias = true,
        blursize = 6
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI128", 5, 5, 255)

    surface.CreateFont("Impulse-LightUI96", {
        font = "DINPro-Light",
        size = 96,
        weight = 100,
        antialias = true,
        blursize = 0
    })

    surface.CreateFont("Impulse-LightUI96-Blurred", {
        font = "DINPro-Light",
        size = 96,
        weight = 100,
        antialias = true,
        blursize = 3
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI96", 4, 4, 255)

    surface.CreateFont("Impulse-LightUI64", {
        font = "DINPro-Light",
        size = 64,
        weight = 100,
        antialias = true,
        blursize = 0
    })

    surface.CreateFont("Impulse-LightUI64-Blurred", {
        font = "DINPro-Light",
        size = 64,
        weight = 100,
        antialias = true,
        blursize = 3
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI64", 3, 3, 255)

    surface.CreateFont("Impulse-LightUI48", {
        font = "DINPro-Light",
        size = 48,
        weight = 100,
        antialias = true,
        blursize = 0
    })

    surface.CreateFont("Impulse-LightUI48-Blurred", {
        font = "DINPro-Light",
        size = 48,
        weight = 100,
        antialias = true,
        blursize = 3
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI48", 3, 3, 255)

    surface.CreateFont("Impulse-LightUI32", {
        font = "DINPro-Light",
        size = 32,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Impulse-LightUI32-Blurred", {
        font = "DINPro-Light",
        size = 32,
        weight = 100,
        antialias = true,
        blursize = 2
    })

    surface.CreateFont("Impulse-LightUI25", {
        font = "DINPro-Light",
        size = 25,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Impulse-LightUI25-Blurred", {
        font = "DINPro-Light",
        size = 25,
        weight = 100,
        antialias = true,
        blursize = 2
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI25", 2, 2, 255)
    
    impulse.Surface.DefineTypeFace("Impulse-LightUI32", 3, 3, 255)

    surface.CreateFont("Impulse-LightUI20", {
        font = "DINPro-Light",
        size = 20,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Impulse-LightUI20-Blurred", {
        font = "DINPro-Light",
        size = 20,
        weight = 100,
        antialias = true,
        blursize = 2
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI20", 2, 2, 255)

    surface.CreateFont("Impulse-LightUI14", {
        font = "DINPro-Light",
        size = 14,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Impulse-LightUI14-Blurred", {
        font = "DINPro-Light",
        size = 14,
        weight = 100,
        antialias = true,
        blursize = 2
    })

    impulse.Surface.DefineTypeFace("Impulse-LightUI14", 2, 2, 255)
end)

local surface=surface

function impulse.Surface.DrawText(text, font, x, y, color, alignX, alignY)

	local typeface = impulse.Surface.Data[font]

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)

	if alignX == TEXT_ALIGN_RIGHT then
		x = x - w
	elseif alignX == TEXT_ALIGN_CENTER then
		x = x - (w/2)
	end

	if alignY == TEXT_ALIGN_BOTTOM then
		y = y - h
	elseif alignY == TEXT_ALIGN_CENTER then
		y = y - (h/2)
	end

	surface.SetFont(font .. "-Blurred")
	surface.SetTextPos(x + typeface["oX"], y + typeface["oY"])
	surface.SetTextColor(ColorAlpha(color_black, typeface["fO"]))
	surface.DrawText(text)

	surface.SetFont(font)
	surface.SetTextPos(x, y)
	surface.SetTextColor(color)
	surface.DrawText(text)

	return w, h

end