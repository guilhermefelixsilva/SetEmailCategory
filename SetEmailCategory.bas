
Sub SetEmailCategory(ByVal sFolder As String, ByVal sFile As String, ByVal sCat As String)
    
On Error GoTo ErrChk

    Application.DisplayAlerts = False
    Dim olApp As Outlook.Application
    Dim objNS As Outlook.Namespace
    Set olApp = Outlook.Application
    Set objNS = olApp.GetNamespace("MAPI")
    Dim olFolder As Outlook.MAPIFolder
    strEmailPath = mdlMain.rfEmailPath
    Set olFolder = GetFolderPath(sFolder)
    If (olFolder Is Nothing) Then
        Set olFolder = GetFolderPath(Replace(sFolder, " [XINSERTHERETHEFOLDEROUTLOOKX]", ""))
    End If
    Dim Item As Object
    
    dMail = Left(sFile, 2) & "/" & Mid(sFile, 3, 2) & "/" & Mid(sFile, 5, 4) & " " & _
        Mid(sFile, 9, 2) & ":" & Mid(sFile, 11, 2) & ":" & Mid(sFile, 13, 2)
    On Error Resume Next
    dMail = CDate(dMail)
    On Error GoTo ErrChk
    cMailChanged = False
    If Not (IsDate(dMail)) Then Exit Sub
    
    For Each Item In olFolder.Items 'Lista Itens
        If TypeOf Item Is Outlook.MailItem Then
            Dim oMail As Outlook.MailItem: Set oMail = Item
            If (Not (oMail Is Nothing) And CDate("" & oMail.CreationTime) = dMail) Then
                oMail.Categories = sCat
                oMail.Save
                cMailChanged = True
                Exit For
            End If
        End If
    Next
    Set olApp = Nothing
    Set objNS = Nothing
    Set olFolder = Nothing
    Set Item = Nothing
    
    Application.DisplayAlerts = True
    
    Exit Sub
    
ErrChk:
    MsgBox Err.Description
    Stop
    Resume
    
End Sub
