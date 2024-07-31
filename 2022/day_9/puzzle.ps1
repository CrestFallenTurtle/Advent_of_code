param(
    [Parameter()]
    [String]$file
)

if ([string]::IsNullOrEmpty($file)){
    "Error: Needs input file"
    "Usage: pwsh puzzle.ps1 <input_file>"
    return 
}

if (-not(Test-Path -Path $file -PathType Leaf)) {
    "Error: Failed to find the provided file"
    return
}

$guts = Get-Content $file
$guts = $guts -split " "
$head = [System.Tuple]::Create(0,0) # Start position
$tail = [System.Tuple]::Create(0,0) # Start position
$history = [System.Collections.ArrayList]@() # This will keep where the tail has been

function DirectionHandler{
    [Parameter ()] [String] $move_set
    [Parameter ()] [System.Tuple] $tuple_obj

    $tuple_x = [int]$tuple_obj.Item1
    $tuple_y = [int]$tuple_obj.Item2

    switch ($move_set) {
        "R" { $tuple_x++ } 
        "L" { $tuple_x-- } 
        "U" { $tuple_y++ } 
        "D" { $tuple_y-- } 
    }    

    $tuple_obj = [System.Tuple]::Create($tuple_y, $tuple_x)

    return $tuple_obj
}

function Main{
    $amount = -1
    $direction = ""
    
    for ($i = 0; $i -lt $guts.length; $i++){

        if ($i%2 -eq 0){ # Direction
            $direction = $guts[$i]

        }else{ # Amount of moves in previous direction
            $amount = [int]$guts[$i]
        }
    
        if ($amount -ne 0){ # We are now ready to operate
            while($amount -gt 0){
                $commands = @{
                    move_set=$direction
                    tuple_obj=$head
                }
                DirectionHandler @commands
                $amount--
            }
            
        }
    }

    $tail_movement = $history.count
    "[PART 1] Tail moved to a total of $tail_movement cells"
}

main