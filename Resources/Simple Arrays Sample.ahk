#SingleInstance, Force
#NoEnv
RAlt::
Browser_Forward::Reload
RControl::
Browser_Back::
;~ ListVars
;***********************Initializing********************************.
GoSub Initialization_Loading_1
;~ GoSub Initialization_Loading_2
;~ GoSub Initialization_Loading_3
;~ GoSub Initialization_Loading_4
;~ GoSub Initialization_Loading_5
;***********************Displaying*******************************.
GoSub No_Loop_Indiv_DisplayValues
;~ GoSub Simple_Loop_Indiv_MessageBox
;~ GoSub Simple_Loop_One_MessageBox
;~ GoSub ForNext_Indiv_MessageBox
;~ GoSub ForNext_Loop_One_MessageBox
;***********************Changing Array********************************.
;~ GoSub Insert
;~ GoSub Append
;~ GoSub Insert_Sparse_Populated
;~ GoSub Remove
;~ GoSub Remove_FirstLastKey
;~ GoSub Remove_Index_LeaveOrder
;~ GoSub Remove_Specific_Value_LeaveOrder
;***********************Misc********************************.
;~ GoSub HasKey
;~ GoSub Release
return
;*******************************************************.
;***********************Initializing********************************.
;*******************************************************.
Initialization_Loading_1:
SimpArray:=[] ;declare the Array / Object
SimpArray[1]:="First Value" ;add values for specific keys
SimpArray[2]:="Second Value"
SimpArray[3]:="Third Value"
SimpArray[4]:=4 ;Values can be strings or text but, in a simple array, the KEYS are all numbers.
return

Initialization_Loading_2:
SimpArray:=[] ;declare the object
SimpArray.1:="First Value" ;add values for specific keys
SimpArray.2:="Second Value"
SimpArray.3:="Third Value"
SimpArray.4:=4 ;Values can be strings or text but, in a simple array, the keys are all numbers.
return

Initialization_Loading_3:
SimpArray := {1:"First Value", 2:"Second Value",3:"Third Value",4:4}
return

Initialization_Loading_4:
SimpArray := ["First Value","Second Value","Third Value",4] ;note- cannot specify starting key
return

Initialization_Loading_5:
SimpArray := Array("First Value","Second Value","Third Value",4) ;note- cannot specify starting key
return
;*******************************************************.
;*****************returning Keys / Values**************************************.
;*******************************************************.
No_Loop_Indiv_DisplayValues:
MsgBox % "Value for key 1 is: " SimpArray[1]
MsgBox % "Value for key 2 is: " SimpArray[2]
MsgBox % "Value for key 3 is: " SimpArray.3
MsgBox % "Value for key 4 is: " SimpArray.4
Return

;*******************************************************.
Simple_Loop_Indiv_MessageBox: ;**Looping through simple array with generic loop and A_Index**************************.
Loop, % SimpArray.MaxIndex() ;MaxIndex() will provide the maximum Key (note this will break when sparsely populated)
MsgBox,,Simple loop using "A_Index", % "Item: " A_Index " has the Value of: " SimpArray[A_Index]
return

;***********************looping through simple array with generic loop and A_Index********************************.
Simple_Loop_One_MessageBox: 
Loop, % SimpArray.MaxIndex() ;MaxIndex() will provide the maximum Key (note this will break when sparsely populated)
List.="Item: " A_Index " has the Value of: " SimpArray[A_Index] "`n"

MsgBox,,Using for loop with one message box, % List
List:=""
return

;***********************For next loop-Indiv messages********************************.
ForNext_Indiv_MessageBox: 
For i, value in SimpArray 
MsgBox,,Using for loop with a messagebox for each iteration ,% "Item: " i " has the value of: " value 
return

;***********************For next loop-One Message box********************************.
ForNext_Loop_One_MessageBox: 
For i, value in SimpArray 
List.="Item: " i " has the value of: " value "`r"

MsgBox,,Using For loop, % List
List:=""
return
;*******************************************************.
;***********************Changing Array********************************.
;*******************************************************.
;*********Insert a key and value at a specific location***************************************.
Insert: 
SimpArray.Insert(2,"Two is back!")
MsgBox % "The Value at 2 is: " simpArray[2]
GoSub ForNext_Loop_One_MessageBox
return

;********Append value to end (adds new key)*************************.
Append: 
SimpArray.Insert("Last")
GoSub ForNext_Loop_One_MessageBox
return

;*******************************************************.
Insert_Sparse_Populated: ;demonstrate that Simple arrays can be sparsely populated
SimpArray.Insert(1000,"Way down the pike")
GoSub ForNext_Loop_One_MessageBox
MsgBox % "Note: when arrays are sparsely populated you cannot use the MaxIndex() function in the loop as it will return the maximum value, not number of items`n`nIn this case the MaxIndex is: " SimpArray.MaxIndex()
Return

;********Remove an item from simple array********************************.
Remove: 
RemovedValue := SimpArray.Remove(2)
MsgBox % "this was just removed from the Simple array: " RemovedValue
MsgBox Now we'll loop through back the simple array to show there are fewer indexes and the keys have shifted
GoSub ForNext_Loop_One_MessageBox
return

;***********************Remove a list of keys********************************.
Remove_FirstLastKey:
SimpArray.Remove(1,2) ;Removes the first two keys & their values. Keys need to be the same type (Integer or String)
GoSub ForNext_Loop_One_MessageBox
SimpArray.Insert(1,"One","Two") ;Here is a simple way to insert multiple values starting from a specific Key
GoSub ForNext_Loop_One_MessageBox
return

;******************Remove key and leave order*************************************.
Remove_Index_LeaveOrder:
SimpArray.Remove(2, "") ;Removes key but leaves placholder so items don't shift
GoSub ForNext_Loop_One_MessageBox
SimpArray[2]:="Second Value" ;Need to set the value here, (not insert) Insert causes others to shift down. Above
GoSub ForNext_Loop_One_MessageBox
return

;********************Remove value and leave key order***********************************.
Remove_Specific_Value_LeaveOrder:
For i, Value in SimpArray 
if (Value="Second Value")
SimpArray.Remove(A_Index,"")

GoSub ForNext_Loop_One_MessageBox
SimpArray[2]:="Second Value" ;Need to set the value here, (not insert) Insert causes others to shift down. Above
return

;***********************check if a specific key exists********************************.
HasKey:
MsgBox % SimpArray.HasKey(3) ;returns 1 because there is a value associated with the 3 key
MsgBox % SimpArray.HasKey(10) ;Returns zero because we do not have a value for key 10
Return

;***********************Release the Array********************************.
Release:
SimpArray:=
goSub ForNext_Loop_One_MessageBox
Return