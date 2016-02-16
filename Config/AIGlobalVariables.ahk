; RegEx Variables
regexOrigFilename := "i)^(_MG_?|DSC_?|APP_|.+? \d{6}D)(0{0,4})(\d{1,5})(\.\w{1,4})(.+)|(0{0,4})(\d{1,5})(.+\.[\w]{1,4})(.+)$"
regexOrigFileNoPSextension := "i)^(_MG_?|DSC_?|APP_|.+? \d{6}D)(0{0,4})(\d{1,5})(\.\w{1,4})|(\d{1,5}).+\.[\w]{1,4}$"
regexPStabTB := "^(.+?)(\.\w{1,4})(.+)$"
regexDateValid := "^(?:20)?\d\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$"
regexDate8Digit := "^20(\d{6})$"
regexDate6Digit := "^(\d{6})$"
regexDir := "^(.+\\)(.+?)\\?$"
regexRemovePSD := "^(.+?)\.psd$"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; File Patterns
BackupFilePattern := "\*.*"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Window Groups
GroupAdd, Photoshop, ahk_class Photoshop
GroupAdd, Photoshop, ahk_class OWL.DocumentWindow
GroupAdd, EmailClient, New Mail
GroupAdd, EmailClient, 1&1 Webmail Inbox
GroupAdd, EmailClient, E-mail and Online Storage
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Webpages
Email := "https://email.1and1.com/appsuite/"
Zenfolio := "http://www.zenfolio.com/flyga/e/all-photos.aspx"
Asana := "https://app.asana.com"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Local Arrays
AppDataBackups := ["\Adobe\Adobe Photoshop CC 2014\Adobe Photoshop CC 2014 Settings", "\Adobe\Bridge CC\Workspaces", "\Adobe\Bridge CC\Favorite Alias", "\Adobe\Bridge CC\Collections", "\Adobe\Bridge CC\Batch Rename Settings", "\Adobe\Bridge CC\Adobe Output Module"]
; Folders
folderArchivesTemp := "Z:\Archives\Temp"
; Email messages:
;~ emailSigProgressEnding := "I was looking at the aerial photo order for this job and saw that it may be ending soon. Do you have an update for us in regards to how much longer you need it photographed?"
;~ emailSigAerialPhotos := "Thank you. Have a wonderful day!"{!}{Enter}-{Space}
;~ emailSigTitleblockApproval := "The draft title block for this project is attached. Please let us know if this looks good or if any changes need to be made."{Enter}Thanks{!}{Enter}