import System.Environment (getArgs)
import System.IO (readFile)

-- Check if a list is strictly increasing or strictly decreasing with valid differences
isSafe :: [Int] -> Bool
isSafe levels = isIncreasing || isDecreasing
  where
    differences = zipWith (-) (tail levels) levels
    
    -- Check if all differences are positive and within the range [1..3]
    isIncreasing = all (\d -> d >= 1 && d <= 3) differences
    
    -- Check if all differences are negative and within the range [-3..-1]
    isDecreasing = all (\d -> d <= -1 && d >= -3) differences

canBeMadeSafe :: [Int] -> Bool
canBeMadeSafe levels = any isSafe (removeEach levels)
  where
    -- Generate all possible lists by removing one element at a time
    removeEach xs = [take i xs ++ drop (i + 1) xs | i <- [0 .. length xs - 1]]

-- Check if a report is safe, with the Problem Dampener rule
isSafeWithDampener :: [Int] -> Bool
isSafeWithDampener levels = isSafe levels || canBeMadeSafe levels

-- Main program
main :: IO ()
main = do
    args <- getArgs
    case args of
        [filename] -> do
            -- Read the file contents
            contents <- readFile filename
        
            -- Parse the file into a list of lists of integers
            let reports = map (map read . words) (lines contents) :: [[Int]]
            
            -- Determine which reports are safe       
            let safeReports = filter isSafe reports

            let safeReports2 = filter isSafeWithDampener reports
            
            -- Output the results
            putStrLn $ "Day 1: " ++ show (length safeReports)

            putStrLn $ "Day 2: " ++ show (length safeReports2)
        
        _ -> putStrLn "Needs an input file in order to work"
