use std::{fs::read_to_string, ops::Index};
use regex::Regex;

fn read_lines(filename: &str) -> Vec<String> {
  let mut result = Vec::new();

  for line in read_to_string(filename).unwrap().lines() {
      result.push(line.to_string())
  }

  result
}

fn generate_grid(gut: Vec<String>) -> Vec<Vec<String>> {
  let mut matrix_map: Vec<Vec<String>> = Vec::new();

  for line in gut {
    let mut matrix_line: Vec<String> = Vec::new();
    
    for c in line.chars() {
      matrix_line.push(c.to_string());
    }

    matrix_map.push(matrix_line);
  }

  return  matrix_map;
}

fn check_left(grid: Vec<Vec<String>>, r:usize, c:usize) -> String {
  let mut left_half = String::new();

  let re = Regex::new(r"(?<digit>\d)").unwrap();
  let Some(result) = re.captures(&grid.index(r).index(c)) else {return left_half};
  
  left_half.push_str(result["digit"].as_ref());
  
  if c.checked_sub(1) == None {
    return left_half;
  }

  left_half.push_str(&check_left(grid, r, c.saturating_sub(1) ));

  return left_half;
}

fn check_right(grid: Vec<Vec<String>>, r:usize, c:usize) -> String {
  let mut right_half = String::new();


  if c >= grid.index(r).len() {
    return right_half;
  }

  let re = Regex::new(r"(?<digit>\d)").unwrap();
  let Some(result) = re.captures(&grid.index(r).index( c)) else {return right_half};
  
  right_half.push_str(result["digit"].as_ref());

  if c.checked_add(1) == None {
    return right_half;
  } 

  right_half.push_str(&check_right(grid, r, c.saturating_add(1) ));

  return right_half;
}

fn collector(grid: Vec<Vec<String>>, r:usize, c:usize) -> String {
  // Check left
  let left = check_left(grid.clone(), r, c).chars().rev().collect::<String>();

  // Check right
  let right = check_right(grid.clone(), r, c+1);

  let collected_result = format!("{}{}", left, right);

  return collected_result.to_string();
}

fn checker(grid: Vec<Vec<String>>, c:usize, r:usize) -> Vec<String> {
  let mut results:Vec<String> = Vec::new();

  // Create cords to investigate
  let left = (c.saturating_sub(1), r);
  let right = (c.saturating_add(1),r);
  
  let up_center = (c, r.saturating_sub(1));
  let up_left = (c.saturating_sub(1), r.saturating_sub(1));
  let up_right = (c.saturating_add(1), r.saturating_sub(1));
  
  let down_center = (c, r.saturating_add(1));
  let down_left = (c.saturating_sub(1), r.saturating_add(1));
  let down_right = (c.saturating_add(1), r.saturating_add(1));

  let grids = vec![left, right, up_center, up_left, up_right, down_center, down_left, down_right];

  for cords in grids {
    if grid.len().le(&cords.1) || grid.index(0).len().le(&cords.0) {
      continue;
    }

    let char: Vec<char> = grid.index(cords.1).index(cords.0).chars().collect();
    
    //println!("{:?}, {:?}, {:?}, {:?}", (c,r),(cords.1, cords.0), (cords.1, cords.0), char);

    // Should only be one value in the char vector
    if char.index(0).is_digit(10) {
      let found_value = collector(grid.clone(), cords.1, cords.0);
      
      if !results.contains(&found_value) {
        //println!("{}", found_value);
        results.push(found_value);
      }
    }

  }

  return results;
}

fn walker(grid: Vec<Vec<String>>) -> i32 {

  let mut result = 0;

  for (r, row) in grid.iter().enumerate() {
    for (c, col) in row.iter().enumerate() {
      // Checking if its a special character
      let re = Regex::new(r"[^\d\.]").unwrap();
      let Some(_) = re.captures(&col) else { continue; };
      
      // It matches, so we gotta do some sicko shit here
      for value in checker(grid.clone(), c, r) {
        result += value.parse::<i32>().unwrap();
      }

    }
  }

  return result;
}

fn walker_2(grid: Vec<Vec<String>>) -> i32 {

  let mut result = 0;

  for (r, row) in grid.iter().enumerate() {
    for (c, col) in row.iter().enumerate() {
      // Checking if its a special character
      let re = Regex::new(r"\*").unwrap();
      let Some(_) = re.captures(&col) else { continue; };
      
      // It matches, so we gotta do some sicko shit here
      let values = checker(grid.clone(), c, r);

      if values.len() < 2 { continue; }

      let mut temp_value = 1;
      for value in values {
        temp_value *= value.parse::<i32>().unwrap();
      }
      result += temp_value;
    }
  }

  return result;
}

fn main() {
  let file = std::env::args().nth(1).expect("no file was provided");

  let gut = read_lines(&file);

  let grid = generate_grid(gut);

  let part_1 = walker(grid.clone());
  let part_2 = walker_2(grid);

  println!("Part 1: {}", part_1);
  println!("Part 2: {}", part_2);

}
