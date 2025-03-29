EnableExplicit
UsePNGImageDecoder()
UseOGGSoundDecoder()
InitSound()
Define Close.a,Event,Direction.b=1,Dir.b=1,Angle.w,Factor.a=2,A,AX,X,Y,SX,KBSPace.a,KBB.a,KBHelp.a,MenuMode.a=0,TitleZoom.a=255,TitleTransparency.a,Temp$,R,OMX,OMY,Help.b=-1,MenuSound.a
Global Dim Rocks.w(0),Level.a=1,Score.q,RockPos=0

Enumeration Sprites
  #S_Hanti
  #S_Left
  #S_Right
  #S_Score
  #S_Background
  #S_Title
  #S_Menu
  #S_Help
EndEnumeration
Enumeration Fonts
  #F_Score
  #F_Title
EndEnumeration
Enumeration Images
  #I_Rock
  #I_Background
  #I_TempBackground
EndEnumeration
Enumeration Sounds
  #So_Click
  #So_Explode
  #So_Hanti
EndEnumeration

Procedure RebuildSprites()
  Protected A
  StartDrawing(SpriteOutput(#S_Left))
  DrawingMode(#PB_2DDrawing_AllChannels)
  For A=ArraySize(Rocks()) To 1 Step -1
    DrawImage(ImageID(#I_Rock),0,200*(A-1))
    DrawImage(ImageID(#I_Rock),200,200*(A-1))
    LineXY(Rocks(A),200*A,Rocks(A-1),200*(A-1),RGB(0,0,255))
  Next    
  FillArea(OutputWidth()-1,0,RGB(0,0,255),RGB(0,0,0))
  StopDrawing()
  
  StartDrawing(SpriteOutput(#S_Right))
  DrawingMode(#PB_2DDrawing_AllChannels)
  For A=ArraySize(Rocks()) To 1 Step -1
    DrawImage(ImageID(#I_Rock),0,200*(A-1))
    DrawImage(ImageID(#I_Rock),200,200*(A-1))
    LineXY(Rocks(A),200*A,Rocks(A-1),200*(A-1),RGBA(0,0,255,255))
  Next    
  FillArea(0,0,RGBA(0,0,255,255),RGB(0,0,0))
  StopDrawing()
EndProcedure

Procedure RebuildScoreSprite()
  Protected Score$="Score: "+Str(Score)
  StartDrawing(SpriteOutput(#S_Score))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,OutputWidth(),OutputHeight(),#Black)
  DrawingFont(FontID(#F_Score))
  DrawText(4,0,"Level: "+Str(Level),#White|$FF000000,#Black)
  DrawText(OutputWidth()-TextWidth(Score$)-4,0,Score$,#White|$FF000000,#Black)
  StopDrawing()
EndProcedure

If InitSprite()=0 Or InitKeyboard()=0; Or InitMouse()=0
  MessageRequester("Error","Can't open the sprite system",0)
  End
EndIf

If OpenWindow(0,300,300,600,800,"Hanti",#PB_Window_SystemMenu)
  If OpenWindowedScreen(WindowID(0),0,0,DesktopScaledX(600),DesktopScaledX(800),0,0,0)
    
    CatchImage(#I_Rock,?Rock)
    CatchImage(#I_Background,?Background)
    CatchSound(#So_Hanti,?Hanti,?Hanti_End-?Hanti)
    CatchSound(#So_Click,?Click,?Hanti-?Click)
    CatchSound(#So_Explode,?Hit,?Click-?Hit)
    
    CreateSprite(#S_Score,DesktopScaledX(WindowWidth(0)),DesktopScaledY(40),#PB_Sprite_AlphaBlending)
    LoadFont(#F_Score,"Courier New",24,#PB_Font_Bold|#PB_Font_HighQuality)
    
    CreateSprite(#S_Title,DesktopScaledX(400),DesktopScaledY(150),#PB_Sprite_AlphaBlending)
    LoadFont(#F_Title,"Courier New",64,#PB_Font_Bold|#PB_Font_HighQuality)
    StartDrawing(SpriteOutput(#S_Title))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),#Black)
    DrawingFont(FontID(#F_Title))
    DrawText((OutputWidth()-TextWidth("Hanti"))/2,(OutputHeight()-TextHeight("Hanti"))/2,"Hanti",#Red|$FF000000,0)
    StopDrawing()
    
    CreateSprite(#S_Menu,DesktopScaledX(600),DesktopScaledY(300),#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(#S_Menu))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),#Black)
    DrawingFont(FontID(#F_Score))
    Temp$="[Space] to start"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,0,Temp$,#Red|$FF000000,0)
    Temp$="[H] for help"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,DesktopScaledY(40),Temp$,#Red|$FF000000,0)
    Temp$="[X] to quit"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,DesktopScaledY(80),Temp$,#Red|$FF000000,0)
    StopDrawing()
    
    CreateSprite(#S_Help,DesktopScaledX(600),DesktopScaledY(300),#PB_Sprite_AlphaBlending)
    StartDrawing(SpriteOutput(#S_Help))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),#Black)
    DrawingFont(FontID(#F_Score))
    Temp$="Don't hit the rocks!"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,0,Temp$,#Red|$FF000000,0)
    Temp$="[Space] to switch pivot"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,DesktopScaledY(40),Temp$,#Red|$FF000000,0)
    Temp$="[B] to switch turn direction"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,DesktopScaledY(80),Temp$,#Red|$FF000000,0)
    Temp$="[H] Back to Main Menu"
    DrawText((OutputWidth()-TextWidth(Temp$))/2,DesktopScaledY(120),Temp$,#Red|$FF000000,0)
    StopDrawing()
    
    CreateSprite(#S_Hanti,DesktopScaledX(300),40,#PB_Sprite_AlphaBlending|#PB_Sprite_PixelCollision)
    StartDrawing(SpriteOutput(#S_Hanti))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),RGB(0,0,0))
    Y=OutputHeight()/2
    R=Y-5
    AX=OutputWidth()/2-Y
    Circle(OutputWidth()-Y,Y,R,RGBA(255,0,0,255))
    Box(OutputWidth()/2,0.5*Y+2,OutputWidth()/2-OutputHeight()+Y,R,RGBA(255,0,0,255))
    Circle(OutputWidth()/2,Y,R,RGBA(255,0,0,255))
    DrawingMode(#PB_2DDrawing_Gradient)
    BackColor($D0D0D0)
    FrontColor($D0D0D0)
    LinearGradient(OutputWidth()/2+0.5*(OutputHeight()+Y),0.5*Y+2,OutputWidth()/2+0.5*(OutputHeight()+Y),1.5*Y-3)
    GradientColor(0.5,$F0F0F0)
    Box(OutputWidth()/2,0.5*Y+2,OutputWidth()/2-OutputHeight()+Y,Y-5,RGBA(255,0,0,255))
    BackColor($C0C0C0)
    FrontColor($D0D0D0)
    CircularGradient(OutputWidth()/2,Y,R)
    Circle(OutputWidth()/2,Y,R,RGBA(255,0,0,255))
    CircularGradient(OutputWidth()-Y,Y,R)
    Circle(OutputWidth()-Y,Y,R,RGBA(255,0,0,255))
    StopDrawing()
    
    CreateSprite(#S_Left,DesktopScaledX(WindowWidth(0))/4,DesktopScaledY(WindowHeight(0))+400,#PB_Sprite_AlphaBlending|#PB_Sprite_PixelCollision)
    CreateSprite(#S_Right,DesktopScaledX(WindowWidth(0))/4,DesktopScaledY(WindowHeight(0))+400,#PB_Sprite_AlphaBlending|#PB_Sprite_PixelCollision)
    Global Dim Rocks(SpriteHeight(#S_Left)/200+1)
    
    CreateImage(#I_TempBackground,DesktopScaledX(WindowWidth(0)),DesktopScaledY(WindowHeight(0)))
    StartDrawing(ImageOutput(#I_TempBackground))
    DrawImage(ImageID(#I_Background),0,0,OutputWidth(),OutputHeight())
    StopDrawing()
    
    Repeat
      
      Repeat
        Event=WindowEvent()
        Select event
          Case #PB_Event_CloseWindow
            Close=#True
        EndSelect
      Until Not Event Or Close
      
      ExamineKeyboard()
      
      Select MenuMode
        Case 0
          ClearScreen(0)
          StartDrawing(ScreenOutput())
          DrawImage(ImageID(#I_TempBackground),0,0)
          StopDrawing()
          
          If TitleZoom>10
            ZoomSprite(#S_Title,#PB_Default,#PB_Default)
            ZoomSprite(#S_Title,10*SpriteWidth(#S_Title)/TitleZoom,10*SpriteHeight(#S_Title)/TitleZoom)
            TitleZoom-6
          Else
            If MenuSound=#False
              MenuSound=#True
              PlaySound(#So_Hanti)
            EndIf
            TitleZoom=0
            ZoomSprite(#S_Title,#PB_Default,#PB_Default)
            If Help=1
              If TitleTransparency<3
                TitleTransparency=0
              Else
                TitleTransparency-3
              EndIf
            Else
              If TitleTransparency<250 And Help<1
                TitleTransparency+3
              Else
                TitleTransparency=255
                Help=0
              EndIf
            EndIf
          EndIf
          DisplayTransparentSprite(#S_Title,(ScreenWidth()-SpriteWidth(#S_Title))/2,(ScreenHeight()-SpriteHeight(#S_Title))/2-200)
          DisplayTransparentSprite(#S_Menu,(ScreenWidth()-SpriteWidth(#S_Menu))/2,(ScreenHeight()-SpriteHeight(#S_Menu))/2+200,TitleTransparency)
          If Help>-1
            DisplayTransparentSprite(#S_Help,(ScreenWidth()-SpriteWidth(#S_Menu))/2,(ScreenHeight()-SpriteHeight(#S_Menu))/2+200,255-TitleTransparency)
          EndIf
          FlipBuffers()
          
          If KeyboardPushed(#PB_Key_Space) And Not KBSpace
            PlaySound(#So_Click)
            MenuMode=1
            KBSPace=#True
            SX=-400
            X=(ScreenWidth()-SpriteWidth(0))/2
            Y=(ScreenHeight()-SpriteHeight(0))/2
            For A=0 To ArraySize(Rocks())
              Rocks(A)=10+Random(SpriteWidth(#S_Left)-20)
            Next
            RebuildSprites()
            Score=0
            Level=1
          EndIf
          If KeyboardPushed(#PB_Key_H) And Not KBHelp
            PlaySound(#So_Click)
            If Help=1
              Help=0
            Else
              Help=1
            EndIf
            KBHelp=#True
          ElseIf KeyboardReleased(#PB_Key_H)
            KBHelp=#False
          EndIf
          If KeyboardPushed(#PB_Key_X)
            PlaySound(#So_Click)
            Break
          EndIf
          
        Case 1
          OMX=X+AX*Cos(Radian(Angle))
          OMY=Y+AX*Sin(Radian(Angle))
          If OMY>DesktopScaledY(WindowHeight(0)) Or OMY<0; Or OMX>DesktopScaledX(WindowWidth(0)) Or OMX<0
            PlaySound(#So_Explode)
            MenuMode=0
            TitleZoom=255
            TitleTransparency=0
            Help=-1
            StartDrawing(ScreenOutput())
            GrabDrawingImage(#I_TempBackground,0,0,OutputWidth(),OutputHeight())
            StopDrawing()
          Else
            If KeyboardPushed(#PB_Key_Space) And Not KBSpace
              Direction=-1*Direction
              KBSpace=#True
              X=X+AX*Cos(Radian(Angle))
              Y=Y+AX*Sin(Radian(Angle))
              Angle+180
            ElseIf KeyboardReleased(#PB_Key_Space)
              KBSpace=#False
            EndIf
            If KeyboardPushed(#PB_Key_B) And Not KBB
              Dir=-1*Dir
              KBB=#True
            ElseIf KeyboardReleased(#PB_Key_B)
              KBB=#False
            EndIf
            If KeyboardPushed(#PB_Key_X)
              Break
            EndIf
            Angle=Angle+3*Dir*Direction
            If Angle>359:Angle-360:EndIf
            If Angle<0:Angle+360:EndIf
            RotateSprite(#S_Hanti,Angle,#PB_Absolute)
            Y+Factor
            ClearScreen(RGB(0,255,0))
            StartDrawing(ScreenOutput())
            DrawImage(ImageID(#I_Background),0,0,OutputWidth(),OutputHeight())
            StopDrawing()
            DisplayTransparentSprite(#S_Hanti,X,Y)
            DisplayTransparentSprite(#S_Left,0,SX)
            DisplayTransparentSprite(#S_Right,DesktopScaledX(WindowWidth(0))-SpriteWidth(#S_Right),SX)
            Score+Factor
            RebuildScoreSprite()
            DisplayTransparentSprite(#S_Score,0,0)
            FlipBuffers()
            SX+Factor
            If SX>-200
              For A=ArraySize(Rocks())-2 To 0 Step -1
                Rocks(A+1)=Rocks(A)
              Next
              Rocks(0)=10+Random(SpriteWidth(#S_Left)-20)
              RebuildSprites()
              SX-200
            EndIf
          EndIf
        
      EndSelect
      
    Until Close
    ;ReleaseMouse(#True)
    
  EndIf
EndIf

XIncludeFile "Resources.pbi"

; IDE Options = PureBasic 6.21 Beta 2 (Windows - x64)
; CursorPosition = 180
; FirstLine = 147
; Folding = ---
; Optimizer
; EnableAsm
; EnableThread
; EnableXP
; DPIAware
; DllProtection
; EnableOnError
; CompileSourceDirectory
; EnableCompileCount = 1
; EnableBuildCount = 0