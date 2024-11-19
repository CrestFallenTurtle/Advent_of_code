package com.aoc.day2;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AdventOfCodeDay2 {
   private static String regex_pattern = "([0-9a-z ,]+)(?:;|\\n|$)";
   private static String game_id = "Game (\\d+)";
   private static String game_values = "(\\d+) (blue|red|green)";

   public static void main(String []args) {
      
      if (args.length == 0) {
        System.out.println("You need to provide a file for the program to work");
        System.exit(1);
      }

      BufferedReader reader;
      HashMap<String, Integer> configuration = new HashMap<String, Integer>();

      configuration.put("red", 12);
      configuration.put("green", 13);
      configuration.put("blue", 14);

      Pattern pattern = Pattern.compile(regex_pattern, Pattern.CASE_INSENSITIVE);
      Pattern game_id_pattern = Pattern.compile(game_id, Pattern.CASE_INSENSITIVE);
      Pattern game_values_pattern = Pattern.compile(game_values, Pattern.CASE_INSENSITIVE);

      int result = 0;
      int part_2_value = 0;

      try {
         reader = new BufferedReader(new FileReader(args[0]));
         String line = reader.readLine();

         while (line != null) {
            Matcher game_matcher = game_id_pattern.matcher(line);
            Matcher matcher = pattern.matcher(line);

            if (game_matcher.find()){
               int game_id = Integer.parseInt(game_matcher.group(1));
               boolean all_okay = true;
               int max_red = 0;
               int max_green = 0;
               int max_blue = 0;

               while(matcher.find()){
                  Matcher values_matcher = game_values_pattern.matcher(matcher.group(1));
                  
                  while(values_matcher.find()) {
                     int value = Integer.parseInt(values_matcher.group(1));
                     String color = values_matcher.group(2);

                     switch (color) {
                        case "red":
                           if (value > max_red) {
                              max_red = value;
                           }

                           break;

                        case "green":
                           if (value > max_green) {
                              max_green = value;
                           }

                           break;

                        case "blue":
                           if (value > max_blue) {
                              max_blue = value;
                           }

                           break;
                     }
                     
                     if (configuration.get(color) < value) {
                        // We found an illegal value
                        all_okay = false;
                     }

                  }
               }

               int temp = max_red * max_green * max_blue;
               

               part_2_value += temp;

               if (all_okay) {
                  result += game_id;
               }

            }
           
            line = reader.readLine();
         }

         reader.close();

         System.out.printf("Part 1: %d\n", result);
         System.out.printf("Part 2: %d\n", part_2_value);

      } catch (IOException e) {
         e.printStackTrace();
      }

   }
   }