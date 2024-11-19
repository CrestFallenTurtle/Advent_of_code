#include "vbcompat.bi"

' Parse the input from command line
Dim As Integer i = 1
Do
    Dim As String arg = Command(i)
    If Len(arg) = 0 Then
        Exit Do
    End If

    i += 1
Loop

' We must have a file to read from
If i = 2 Then
    Print "Error: Need an input file to work!"
    Print "Error: Need the amount of characters to gather"
    Print "USAGE: ./puzzle <file/to/read> <amount_of_characters>"
    end
End If

Dim as String file_input = Command(1)
Dim as Integer marker_roof = Val(Command(2))

' Check if the file exist and/or we have permissions to read it
If FileExists(file_input) = false Then
  Print "Error: Failed to find file " & file_input
  end
End If

' Read the file
Dim gut As String
Open file_input For Input As #1
Line Input #1, gut
Close #1

Dim as Integer length = Len(gut) ' Grab the length of the input

Dim marker(marker_roof) as Integer
Dim as Integer marker_is_full = 0

for i = 0 to length

    ' -- Part 1 --
    for y as Integer = 0 to marker_roof
        If gut[i] = marker(y) Then ' Does the array already contain this value?
            marker_is_full = 0 ' Reset the size
            
            for k as Integer = 0 to y ' Then we must remove everything up to this point
                marker(k) = 0
            next

            Dim as Integer z = 0
            for k as Integer = y to marker_roof ' Shift down the last values
                If marker(k) <> 0 Then ' Let's not keep it if it's a zero value
                    marker(z) = marker(k)
                    marker(k) = 0 ' Remove the old value
                    z += 1
                    marker_is_full += 1 ' For each value shifted down, increment the size
                End if
            next

        
            exit for ' No need to keep looking
        
        End if
    next

    ' Let us add it!
    for y as Integer = 0 to marker_roof
        If marker(y) = 0 Then ' Found an empty spot so let us insert it
            marker(y) = gut[i] ' Copy over the value
            marker_is_full += 1 ' Add a value!
            exit for
        End if
    next

    If marker_is_full >= marker_roof Then
        Dim as String character
        for y as Integer = 0 to marker_roof
            character += Chr(marker(y))
        next

        Print "Marker is full after: " & i+1 & " characters, " & character
        end
    End if
next