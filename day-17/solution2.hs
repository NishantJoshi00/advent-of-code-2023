import Data.Char (digitToInt)
import Data.List (sort)
import Data.Set (Set, empty, insert, member)
import GHC.IO (unsafePerformIO)

main :: IO ()
main = interact solve

solve :: String -> String
solve out = show (dijkstra input_data [(0, 0, 0, 0, 0, 0)] empty)
 where
  input_data = arrify out

-- dijkstra :: Input -> Triversal -> Seen ->
dijkstra :: [[Int]] -> [(Int, Int, Int, Int, Int, Int)] -> Set (Int, Int, Int, Int, Int) -> Int
dijkstra grid trav seen
  | r == length grid - 1 && c == length (head grid) - 1 && d >= 4 = hl
  | member (r, c, dr, dc, d) seen = dijkstra grid (tail trav) seen
  | otherwise = dijkstra grid (sort $ tail trav ++ newTrev grid (hl, r, c, dr, dc, d)) (insert (r, c, dr, dc, d) seen)
 where
  (hl, r, c, dr, dc, d) = head trav

arrify str = fmap digitToInt <$> lines str

newTrev :: [[Int]] -> (Int, Int, Int, Int, Int, Int) -> [(Int, Int, Int, Int, Int, Int)]
newTrev grid (hl, r, c, dr, dc, d) =
  ( if d < 10 && ((dr, dc) /= (0, 0))
      then gridAdd grid (hl, r, c, dr, dc, d)
      else []
  )
    ++ ( if d >= 4 || (dr, dc) == (0, 0)
          then
            concatMap
              (\(a, b) -> gridAdd grid (hl, r, c, a, b, 0))
              ( filter
                  (\x -> x /= (dr, dc) && x /= (-dr, -dc))
                  [(0, 1), (1, 0), (0, -1), (-1, 0)]
              )
          else []
       )

gridAdd :: [[Int]] -> (Int, Int, Int, Int, Int, Int) -> [(Int, Int, Int, Int, Int, Int)]
gridAdd grid (hl, r, c, dr, dc, d)
  | 0 <= nr && nr < length grid && 0 <= nc && nc < length (head grid) = [(hl + (grid !! nr !! nc), nr, nc, dr, dc, d + 1)]
  | otherwise = []
 where
  nr = r + dr
  nc = c + dc

-- if (n < 3 && (dr, dc) != (0, 0)) && (0 <= nr && nr < (length grid) && 0 <= nc && nc < length(head grid)) then
--
unsafeShow :: Show a => a -> a
unsafeShow a = unsafePerformIO $ safeShow a

safeShow :: Show a => a -> IO a
safeShow a = do
  print a
  return a
